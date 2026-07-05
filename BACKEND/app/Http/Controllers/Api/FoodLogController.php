<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use App\Models\Screening;
use App\Services\PointService;
use App\Services\StreakService;
use Illuminate\Support\Facades\Log;



class FoodLogController extends Controller
{
    /**
     * API KHUSUS: Menerima & memproses input dari Volt Agent (WhatsApp)
     * Alur: Volt kirim teks makanan -> Laravel cari di DB -> Jika ada pakai kalori DB, jika tidak pakai kalori AI
     */
    public function storeFromWhatsApp(Request $request)
    {
        // 1. Validasi data masuk dari Volt Agent
        $request->validate([
            'whatsapp_number' => 'required',
            'makanan_input'   => 'required|string',
            'porsi'           => 'required',
            'estimasi_kalori_ai' => 'required|integer' // Estimasi cadangan dari LLM Volt
        ]);

        // 2. Cari user berdasarkan nomor WhatsApp
        $user = DB::table('users')
            ->where('phone_number', 'like', '%' . $request->whatsapp_number . '%')
            ->first();

        // Jika nomor WA tidak terdaftar, gunakan ID default (misal: 1) agar sistem tidak crash
        $userId = $user ? $user->id : 1;

        // 3. Cari makanan di database lokal Indonesia (Food Matching)
        $food = DB::table('foods')
            ->where('name', 'like', '%' . $request->makanan_input . '%')
            ->first();

        if ($food) {
            // JIKA COCOK: Gunakan ID makanan asli dan hitung kalori dari database
            $foodId = $food->id;
            $totalKalori = $food->kalori * (float)$request->porsi;
            $matchStatus = "Matched with Database";
        } else {
            // JIKA TIDAK COCOK (Unknown Food): Gunakan ID default/NULL, kalori pakai hitungan LLM Volt
            $foodId = 1; // Pastikan ada ID 1 dengan nama "Makanan Lainnya/Estimasi AI" di tabel foods kamu
            $totalKalori = $request->estimasi_kalori_ai;
            $matchStatus = "Estimated by AI (Food Not Found in DB)";
        }

        $waktuMakan = Carbon::now()->toTimeString();
        $tanggalCatat = Carbon::now()->toDateString();

        // 4. Simpan ke Serial DB (Tabel food_logs)
        DB::table('food_logs')->insert([
            'user_id'       => $userId,
            'food_id'       => $foodId,
            'porsi'         => $request->porsi,
            'total_kalori'  => $totalKalori,
            'waktu_makan'   => $waktuMakan,
            'tanggal_catat' => $tanggalCatat,
            'created_at'    => Carbon::now(),
            'updated_at'    => Carbon::now()
        ]);
PointService::add(
    $userId,
    'food_log',
    10
);

StreakService::update(
    $userId
);

        // 5. Beri respon balik ke Volt Agent untuk dikirim sebagai chat balasan WA ke user
        return response()->json([
            'success'      => true,
            'message'      => 'Berhasil dicatat lewat WhatsApp!',
            'match_status' => $matchStatus,
            'data' => [
                'user_id'      => $userId,
                'makanan'      => $food ? $food->name : $request->makanan_input,
                'porsi'        => $request->porsi,
                'total_kalori' => $totalKalori
            ]
        ], 201);
    }

    // ==========================================
    // FUNGSI BAWAANMU (YANG SUDAH ADA SEBELUMNYA)
    // ==========================================

    // Simpan makanan ke jurnal harian via Web/Manual
    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'food_id' => 'required',
            'porsi' => 'required',
            'total_kalori' => 'required'
        ]);

        $waktuMakan = $request->input('waktu_makan', Carbon::now()->toTimeString());
        $tanggalCatat = $request->input('tanggal_catat', Carbon::now()->toDateString());

        $food = DB::table('foods')
            ->where('id', $request->food_id)
            ->first();

        DB::table('food_logs')->insert([
            'user_id' => $request->user_id,
            'food_id' => $request->food_id,
            'food_name' => $food ? $food->name : 'Unknown Food',
            'portion' => $request->porsi,
            'total_calories' => $request->total_kalori,
            'log_date' => Carbon::now()->toDateString(),
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);
try {

    PointService::add(
        $request->user_id,
        'food_log',
        10
    );

    StreakService::update(
        $request->user_id
    );

} catch (\Exception $e) {

    dd($e->getMessage());

}

        return response()->json(['success' => true, 'message' => 'Berhasil disimpan!'], 201);
    }

    // Ambil data makan hari ini
public function today($user_id)
{
    $today = Carbon::today()->toDateString();

    $logs = DB::table('food_logs')
        ->join('foods', 'food_logs.food_id', '=', 'foods.id')
        ->select(
            'food_logs.*',

            'foods.protein',
            'foods.carbs',
            'foods.fat',
            'foods.serving_size',
            'foods.name as database_food_name'
        )
        ->where('food_logs.user_id', $user_id)
        ->where('food_logs.log_date', $today)
        ->orderBy('food_logs.created_at', 'desc')
        ->get();

    $totalKalori = $logs->sum('total_calories');

    $totalProtein = $logs->sum(function ($item) {
        return $item->protein * $item->portion;
    });

    $totalCarbs = $logs->sum(function ($item) {
        return $item->carbs * $item->portion;
    });

    $totalFat = $logs->sum(function ($item) {
        return $item->fat * $item->portion;
    });

    $latestScreening = Screening::where('user_id', $user_id)
        ->latest()
        ->first();

    return response()->json([
        'success'=>true,

        'total_kalori'=>$totalKalori,

        'total_protein'=>round($totalProtein),

        'total_carbs'=>round($totalCarbs),

        'total_fat'=>round($totalFat),

        'logs'=>$logs,

        'latest_screening'=>$latestScreening,

        'alert_message'=>'',

        'reminder_message'=>''
    ]);
}

    // Ambil Analisis Kebiasaan (Obesity Risk Alert & Smart Reminder)
    public function getAnalysis($user_id)
    {
        $user = DB::table('users')->where('id', $user_id)->first();
        $firstName = $user ? explode(' ', $user->name)[0] : 'Pengguna';

        $sevenDaysAgo = Carbon::now()->subDays(7)->toDateString();

        $sweetDrinksCount = DB::table('food_logs')
            ->join('foods', 'food_logs.food_id', '=', 'foods.id')
            ->where('food_logs.user_id', $user_id)
            ->where('food_logs.log_date', '>=', $sevenDaysAgo)
            ->where(function($query) {
                $query->where('foods.name', 'like', '%manis%')
                      ->orWhere('foods.name', 'like', '%es teh%')
                      ->orWhere('foods.name', 'like', '%kopi susu%')
                      ->orWhere('foods.name', 'like', '%gula%');
            })->count();

        $lateNightMeals = DB::table('food_logs')
            ->where('user_id', $user_id)
            ->whereRaw('HOUR(created_at) >= 20')
            ->count();

        $alert = "";
        if ($sweetDrinksCount >= 4) {
            $alert = "Wah $firstName, dalam 7 hari ini kamu sudah $sweetDrinksCount kali konsumsi manis. Yuk, batasi dulu agar progresmu lancar! ✨";
        }

        $reminder = "Halo $firstName, jangan lupa minum air putih sebelum makan siang ya!";
        if ($lateNightMeals >= 3) {
            $reminder = "$firstName, coba majukan jam makan malammu sebelum jam 19.00 agar tidurmu lebih nyenyak.";
        }

        return response()->json([
            'success' => true,
            'alert_message' => $alert,
            'reminder_message' => $reminder
        ]);
    }

    // Mencari makanan berdasarkan nama
    public function searchFood(Request $request)
    {
        $query = $request->query('query');
        
        if (!$query) {
            return response()->json(['success' => false, 'message' => 'Query pencarian kosong'], 400);
        }

        $foods = DB::table('foods')
            ->where('foods.name', 'like', '%' . $query . '%')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $foods
        ]);
    }
    public function history($userId)
{
    $logs = DB::table('food_logs')
        ->join('foods', 'food_logs.food_id', '=', 'foods.id')
        ->select(
            'food_logs.*',

            'foods.protein',

            'foods.carbs',

            'foods.fat',

            'foods.serving_size'
        )
        ->where('food_logs.user_id', $userId)
        ->orderBy('food_logs.log_date', 'desc')
        ->orderBy('food_logs.created_at', 'desc')
        ->get();

    return response()->json([
        'success' => true,
        'data' => $logs
    ]);
}
}
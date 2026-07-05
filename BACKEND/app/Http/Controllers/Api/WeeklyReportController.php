<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WeeklyReport;
use App\Models\Screening;
use App\Models\FoodLog;
use Carbon\Carbon;
use App\Models\User;
use App\Models\CoachingHistory;

class WeeklyReportController extends Controller
{
    public function generate($user_id)
    {
        // minggu sekarang
        $start = Carbon::now()->startOfWeek();
        $end = Carbon::now()->endOfWeek();

        // screening minggu ini
        $screenings = Screening::where('user_id', $user_id)
            ->whereBetween('created_at', [$start, $end])
            ->orderBy('created_at')
            ->get();

        $weightChange = 0;

        if ($screenings->count() >= 2) {

            $weightAwal = $screenings->first()->weight;
            $weightAkhir = $screenings->last()->weight;

            $weightChange = $weightAkhir - $weightAwal;
        }

        // food log minggu ini
        $foodLogs = FoodLog::where('user_id', $user_id)
            ->whereBetween('log_date', [$start, $end])
            ->get();

            // riwayat makanan minggu ini
        $foodHistory = $foodLogs;

        // top 3 makanan
        $topFoods = $foodLogs
            ->groupBy('food_name')
            ->sortByDesc(function ($item) {
                return count($item);
            })
            ->take(3)
            ->map(function ($item, $key) {

                return [
                    'food_name' => $key,
                    'jumlah' => count($item)
                ];

            })
            ->values();

        // progress berat badan
        $weightHistory = Screening::where(
                'user_id',
                $user_id
            )
            ->select(
                'weight',
                'created_at'
            )
            ->orderBy('created_at')
            ->get();

        // coaching terakhir
        $coaching = CoachingHistory::with(
                'template'
            )
            ->where(
                'user_id',
                $user_id
            )
            ->latest()
            ->first();

            // screening terbaru
            $latestScreening = Screening::where(
                    'user_id',
                    $user_id
                )
                ->latest()
                ->first();

        // rata-rata kalori
        $avgCalories = 0;

        if ($foodLogs->count() > 0) {

            $avgCalories = round(
                $foodLogs->avg('total_calories')
            );
        }

        // makanan yang paling sering
        $frequentFood = '-';

        if ($foodLogs->count() > 0) {

            $frequentFood =
                $foodLogs
                    ->groupBy('food_name')
                    ->sortByDesc(function ($item) {
                        return count($item);
                    })
                    ->keys()
                    ->first();
        }

        // screening terbaru
        $latestScreening = Screening::where(
            'user_id',
            $user_id
        )->latest()->first();

        $recommendation = "Pertahankan pola makan sehat.";

        if ($latestScreening) {

            if ($latestScreening->imt_classification == 'Obesity II') {

                $recommendation =
                    "Kurangi minuman manis dan lakukan jalan kaki 20 menit setiap hari.";
            }

            elseif ($latestScreening->imt_classification == 'Overweight') {

                $recommendation =
                    "Kurangi camilan tinggi gula dan perbanyak aktivitas.";
            }
        }

        $reportText =
            "Minggu ini rata-rata kalori harianmu "
            . $avgCalories .
            " kcal. Makanan yang paling sering dikonsumsi adalah "
            . $frequentFood .
            ". Perubahan berat badan minggu ini sebesar "
            . $weightChange .
            " kg.";

        $report = WeeklyReport::updateOrCreate(

            [
                'user_id' => $user_id,
                'period_start' => $start
            ],

            [
                'period_end' => $end,
                'report_text' => $reportText,
                'avg_calories' => $avgCalories,
                'weight_change' => $weightChange,
                'frequent_food' => $frequentFood,
                'recommendation' => $recommendation
            ]

        );

        $user = User::find($user_id);

        return response()->json([

            'success' => true,

            'user' => $user,

            'data' => $report,

            'food_history' => $foodHistory,

            'top_foods' => $topFoods,

            'weight_history' => $weightHistory,

            'coaching' => $coaching,

            'latest_screening' => $latestScreening

        ]);
    }
}
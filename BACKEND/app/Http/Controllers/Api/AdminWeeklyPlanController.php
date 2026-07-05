<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminWeeklyPlanController extends Controller
{
    public function getAllPlans()
    {
        // Ambil data dari tabel weekly_plans dan joinkan dengan users
        $plans = DB::table('weekly_plans')
            ->join('users', 'weekly_plans.user_id', '=', 'users.id')
            ->select('weekly_plans.*', 'users.name as user_name')
            ->orderBy('weekly_plans.id', 'desc')
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'user_id' => $item->user_id,
                    'user' => [
                        'name' => $item->user_name ?? 'Pengguna #' . $item->user_id
                    ],
                    'focus' => $item->focus ?? '-',
                    'activity_target' => $item->activity_target ?? '-',
                    'small_habit' => $item->small_habit ?? '-',
                    'menu_recommendation' => $item->menu_recommendation ?? '-',
                    
                    // PENTING: Tambahkan baris ini agar dibaca oleh filter 'Aktif' di AIWeight.jsx kamu!
                    'status' => 'Aktif' 
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $plans
        ], 200);
    }
}
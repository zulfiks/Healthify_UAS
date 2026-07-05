<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class AdminFoodStatisticsController extends Controller
{
    public function index()
    {
        // Makanan paling sering dikonsumsi
        $topFoods = DB::table('food_logs')
            ->join('foods', 'food_logs.food_id', '=', 'foods.id')
            ->select(
                'foods.name',
                DB::raw('COUNT(food_logs.id) as total')
            )
            ->groupBy('foods.id', 'foods.name')
            ->orderByDesc('total')
            ->limit(5)
            ->get();

        // Makanan kalori tertinggi
        $highCalories = DB::table('foods')
            ->select(
                'name',
                DB::raw('calories as total_kalori')
            )
            ->orderByDesc('calories')
            ->limit(5)
            ->get();

        // Tren konsumsi user
        $trend = DB::table('food_logs')
            ->select(
                'log_date as tanggal_catat',
                DB::raw('SUM(total_calories) as total_kalori')
            )
            ->groupBy('log_date')
            ->orderBy('log_date')
            ->get();

        return response()->json([
            'success' => true,
            'top_foods' => $topFoods,
            'high_calories' => $highCalories,
            'trend' => $trend,
        ]);
    }
}
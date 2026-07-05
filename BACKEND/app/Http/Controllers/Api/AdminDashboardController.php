<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\FoodLog;
use App\Models\Screening;

class AdminDashboardController extends Controller
{
    public function index()
    {
        $totalUsers = User::count();

        $totalFoodLogs = FoodLog::count();

        $screenings = Screening::all();

        $normal = 0;
        $overweight = 0;
        $obesity = 0;
        $critical = 0;

        foreach ($screenings as $screening) {

            $classification =
                $screening->imt_classification;

            if (
                str_contains(
                    strtolower($classification),
                    'normal'
                )
            ) {
                $normal++;
            }
            elseif (
                str_contains(
                    strtolower($classification),
                    'overweight'
                )
            ) {
                $overweight++;
            }
            elseif (
                str_contains(
                    strtolower($classification),
                    'obesity i'
                )
            ) {
                $obesity++;
            }
            elseif (
                str_contains(
                    strtolower($classification),
                    'obesity ii'
                )
            ) {
                $critical++;
            }
        }

$recentAlerts = Screening::with('user')
    ->where('risk_level', 'High')
    ->latest()
    ->take(5)
    ->get()
    ->map(function ($item) {

        return [

            'id' => $item->id,

            'user' => $item->user->name ?? '-',

            'bmi' => $item->imt_value,

            'status' => $item->risk_level,

            'created_at' => $item->created_at
                ->format('d M Y'),
        ];
    });

                $obesityAlerts = Screening::where(
    'risk_level',
    'High'
)->count();

return response()->json([

    'total_users' => $totalUsers,

    'total_food_logs' => $totalFoodLogs,

    'obesity_alerts' => $obesityAlerts,

    'recent_alerts' => $recentAlerts,

]);
    }
}
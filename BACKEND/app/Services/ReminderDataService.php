<?php

namespace App\Services;

use App\Models\User;
use App\Models\Screening;
use App\Models\FoodLog;
use App\Models\ActivityLog;
use App\Models\WeeklyPlan;
use App\Models\WeeklyReport;

class ReminderDataService
{
    public function getUserData($userId)
    {

        $user = User::findOrFail($userId);

        $screening = Screening::where(
            'user_id',
            $userId
        )
        ->latest()
        ->first();

        $foodLogs = FoodLog::where(
            'user_id',
            $userId
        )
        ->latest()
        ->take(10)
        ->get();

        $activityLogs = ActivityLog::where(
            'user_id',
            $userId
        )
        ->latest()
        ->take(10)
        ->get();

        $weeklyPlan = WeeklyPlan::where(
            'user_id',
            $userId
        )
        ->latest()
        ->first();

        $weeklyReport = WeeklyReport::where(
            'user_id',
            $userId
        )
        ->latest()
        ->first();

        return [

            'user'=>$user,

            'screening'=>$screening,

            'food_logs'=>$foodLogs,

            'activity_logs'=>$activityLogs,

            'weekly_plan'=>$weeklyPlan,

            'weekly_report'=>$weeklyReport,

            'food_history'=>$foodLogs
                ->pluck('food_name')
                ->implode(', '),

            'activity_history'=>$activityLogs
                ->pluck('activity_type')
                ->implode(', '),

            'avg_calories'=>

                round(

                    $foodLogs
                    ->avg('total_calories')

                    ?? 0

                ),

            'burned'=>

                $activityLogs
                ->sum('calories_burned')

        ];

    }
}
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserStreak;
use Carbon\Carbon;

class StreakController extends Controller
{
    public function getStreak($user_id)
    {
        $streak = UserStreak::where(
            'user_id',
            $user_id
        )->first();

        if (!$streak) {

            return response()->json([
                'success' => true,
                'current_streak' => 0,
                'best_streak' => 0,
                'is_active' => false
            ]);

        }

      $isActive = false;

if ($streak->last_activity_date) {

    $days = Carbon::parse(
        $streak->last_activity_date
    )->diffInDays(Carbon::today());

    $isActive = ($days == 0);
}

$currentStreak = $streak->current_streak;

if ($streak->last_activity_date) {

    $days = Carbon::parse(
        $streak->last_activity_date
    )->diffInDays(Carbon::today());

    if ($days > 1) {

        $currentStreak = 0;

    }
}
return response()->json([
    'success' => true,
    'current_streak' => $currentStreak,
    'best_streak' => $streak->best_streak,
    'is_active' => $isActive
]);
    }
}
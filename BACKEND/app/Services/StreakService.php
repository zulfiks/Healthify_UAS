<?php

namespace App\Services;

use App\Models\UserStreak;
use Carbon\Carbon;

class StreakService
{
    public static function update($userId)
    {
        $streak = UserStreak::firstOrCreate(
            ['user_id' => $userId],
            [
                'current_streak' => 0,
                'best_streak' => 0
                
            ]
        );

        $today = Carbon::today();

        if (!$streak->last_activity_date) {

            // Pertama kali input
            $streak->current_streak = 1;

        } else {

            $lastDate = Carbon::parse(
                $streak->last_activity_date
            );

            $days = $lastDate->diffInDays($today);

            if ($days == 0) {

                // Sudah input hari ini
                // Tidak menambah streak

            } elseif ($days == 1) {

                // Lanjut streak
                $streak->current_streak++;

            } else {

                // Streak putus
                // Mulai lagi dari 1
                $streak->current_streak = 1;

            }
        }

        if ($streak->current_streak > $streak->best_streak) {

            $streak->best_streak =
                $streak->current_streak;

        }

        $streak->last_activity_date = $today;

        $streak->save();
    }
}
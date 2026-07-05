<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;

class ExpertDashboardController extends Controller
{
    public function index()
    {
        $users = User::with([
            'latestScreening',
            'expertReview',
            'foodLogs'
        ])->get();

        $result = $users->map(function ($user) {

            return [

                'id' => $user->id,

                'name' => $user->name,

                'email' => $user->email,

                'goal' => $user->goal,

                'profile_picture' => $user->profile_picture,

                'bmi' => optional(
                    $user->latestScreening
                )->imt_value,

                'risk_level' => optional(
                    $user->latestScreening
                )->risk_level,

                'food_logs' => $user
                    ->foodLogs
                    ->count(),

                'review_status' => optional(
                    $user->expertReview
                )->status ?? "Belum Direview",

            ];

        });

        return response()->json([

            'success' => true,

            'data' => $result

        ]);

    }
}
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\WeeklyPlan;
use App\Services\AIPlanService;
use App\Models\Screening;
use App\Models\FoodLog;

class WeeklyPlanController extends Controller
{
    public function getPlan($user_id)
    {
        
    $user = User::findOrFail($user_id);
    $goal = $user->goal;

    $avgCalories = FoodLog::where('user_id',$user_id)
    ->latest()
    ->take(7)
    ->avg('total_calories');

    

    $screening = Screening::where('user_id', $user_id)
        ->latest()
        ->first();
    $lastScreening = Screening::where('user_id',$user_id)
    ->latest()
    ->skip(1)
    ->first();

    $previousWeight = $lastScreening
        ? $lastScreening->weight
        : $screening->weight;

    $foods = FoodLog::where('user_id', $user_id)
        ->latest()
        ->take(7)
        ->pluck('food_name')
        ->implode(', ');

    $foodName = $foods ?: "Tidak ada data";

    $aiPlanService = new AIPlanService(
        new \App\Services\GroqService()
    );

    $aiPlanText = $aiPlanService
->generatePlan(
    $screening,
    $foodName,
    $goal,
    $avgCalories,
    $previousWeight
);

    $lines = explode("\n\n", $aiPlanText);

    $focus = str_replace("Focus: ", "", $lines[0] ?? "");
    $activityTarget = str_replace("Activity Target: ", "", $lines[1] ?? "");
    $smallHabit = str_replace("Small Habit: ", "", $lines[2] ?? "");
    $menuRecommendation = str_replace(
        "Menu Recommendation: ",
        "",
        $lines[3] ?? ""
    );

    $plan = WeeklyPlan::updateOrCreate(
        [
            'user_id' => $user_id
        ],
        [
            'focus' => $focus,
            'activity_target' => $activityTarget,
            'small_habit' => $smallHabit,
            'menu_recommendation' => $menuRecommendation,
        ]
    );

    return response()->json([
        'success' => true,
        'data' => $plan
    ]);
}
}
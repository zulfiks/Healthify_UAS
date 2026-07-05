<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Screening;
use App\Models\WeightLossPlan;
use App\Services\AIPlanService;
use App\Models\FoodLog;
use Illuminate\Support\Facades\DB;

class WeightLossPlanController extends Controller
{
    public function generate(
    $user_id,
    AIPlanService $aiPlanService
)
{

    $screening = Screening::where(
        'user_id',
        $user_id
    )->latest()->first();

    if (!$screening) {

        return response()->json([
            'success' => false,
            'message' => 'Belum screening'
        ]);
    }

    $topFood = FoodLog::where('user_id', $user_id)
    ->join('foods', 'foods.id', '=', 'food_logs.food_id')
    ->select(
        'foods.name',
        DB::raw('COUNT(*) as total')
    )
    ->groupBy('foods.name')
    ->orderByDesc('total')
    ->value('foods.name');

if (!$topFood) {

    $topFood = "Belum ada riwayat makanan";

}


$goal = $screening->imt_value < 18.5
    ? 'Menaikkan berat badan'
    : (
        $screening->imt_value < 25
            ? 'Mempertahankan berat badan'
            : 'Menurunkan berat badan'
    );

    $avgCalories = round(

    FoodLog::where('user_id', $user_id)

        ->avg("total_calories")

);

    $previousWeight = $screening->weight;

    $plan = $aiPlanService->generatePlan(
        $screening,
        $topFood,
        $goal,
        $avgCalories,
        $previousWeight
    );

    WeightLossPlan::updateOrCreate(

        [
            'user_id' => $user_id
        ],

        [
            'plan_text' => $plan,
            'generated_at' => now()
        ]

    );

    return response()->json([
        'success' => true,
        'plan' => $plan
    ]);
    }
}
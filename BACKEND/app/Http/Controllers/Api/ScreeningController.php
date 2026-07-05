<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Screening;
use App\Services\PointService;
use App\Services\StreakService;
use Illuminate\Support\Facades\Log;

class ScreeningController extends Controller
{
    public function store(Request $request)
    {
        $weight = (float) $request->weight;
        $height = (float) $request->height;
        $waist = (float) $request->waist;
        $age = (int) $request->age;
        $gender = strtolower($request->gender);

        $heightMeter = $height / 100;

        $imt = $weight / ($heightMeter * $heightMeter);

        // BMI
        if ($imt < 18.5) {

            $imtClass = 'Underweight';
            $riskLevel = 'Low';

        } elseif ($imt <= 22.9) {

            $imtClass = 'Normal';
            $riskLevel = 'Normal';

        } elseif ($imt <= 24.9) {

            $imtClass = 'Overweight';
            $riskLevel = 'Moderate';

        } elseif ($imt <= 29.9) {

            $imtClass = 'Obesity I';
            $riskLevel = 'High';

        } else {

            $imtClass = 'Obesity II';
            $riskLevel = 'Very High';
        }

        // Central obesity
        $isCentralObesity =
            ($gender == 'male' && $waist > 90) ||
            ($gender == 'female' && $waist > 80);

        $centralStatus =
            $isCentralObesity
                ? 'Central Obesity'
                : 'Normal';

        // =========================
        // AI PLAN
        // =========================

        $weeklyTarget =
            'Menjaga pola hidup sehat';

        $activityTarget =
            'Olahraga ringan';

        $foodRecommendation =
            'Perbanyak konsumsi sayur';

        $habitRecommendation =
            'Minum air putih cukup';

        if ($imt >= 25) {

            $weeklyTarget =
                'Turun 0.5 - 1 kg secara bertahap';

            $activityTarget =
                'Low impact cardio 30 menit';

            $foodRecommendation =
                'Kurangi makanan ultra processed';

            $habitRecommendation =
                'Hindari makan larut malam';
        }

        // SAVE
        $screening = $screening = new Screening();
        $screening->user_id = $request->user_id;
        $screening->weight = $weight;
        $screening->height = $height;
        $screening->waist = $waist;
        $screening->age = $age;
        $screening->gender = $gender;

        $screening->imt_value = round($imt, 1);
        $screening->imt_classification = $imtClass;

        $screening->risk_level = $riskLevel;
        $screening->central_obesity_status = $centralStatus;

        $screening->sarc_f_score = null;
        $screening->sarcopenia_status = null;
$screening->activity_level = $request->activity_level;
$screening->sweet_drink = $request->sweet_drink;
$screening->fast_food = $request->fast_food;
$screening->sleep_duration = $request->sleep_duration;
$screening->sitting_duration = $request->sitting_duration;
$screening->fatigue = $request->fatigue;

$screening->conditions =
    json_encode(
        $request->conditions
    );
        $screening->save();
try {

    PointService::add(
        $request->user_id,
        'screening',
        15
    );

    StreakService::update(
        $request->user_id
    );

} catch (\Exception $e) {

    dd($e->getMessage());

}

        return response()->json([
            'success' => true,
            'data' => $screening
        ]);
    }

    public function history($user_id)
    {
        $history = Screening::where('user_id', $user_id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $history
        ]);
    }

    public function latest($user_id)
    {
        $latest = Screening::where('user_id', $user_id)
            ->latest()
            ->first();

        if (!$latest) {

            return response()->json([
                'success' => false,
                'message' => 'Belum ada data screening'
            ], 404);

        }

        return response()->json([
            'success' => true,
            'data' => $latest
        ]);
    }
}
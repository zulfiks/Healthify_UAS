<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ActivityRecommendation;
use App\Models\Screening;
use App\Models\ActivityProgram;

class ActivityRecommendationController extends Controller
{
    public function getRecommendation($user_id)
    {
        $screening = Screening::where('user_id',$user_id)
                    ->latest()
                    ->first();

        if(!$screening){
            return response()->json([
                'success'=>false,
                'message'=>'Data screening tidak ditemukan'
            ]);
        }

        $bmi = $screening->imt_value;
$risk = strtolower($screening->risk_level ?? '');

$program = ActivityProgram::firstOrCreate(
    [
        'user_id' => $user_id
    ],
    [
        'current_week' => 1,
        'completed_sessions' => 0
    ]
);

$activity = ActivityRecommendation::where(
    'week',
    $program->current_week
)->first();

if (!$activity) {

    return response()->json([
        'success' => false,
        'message' => 'Rekomendasi tidak ditemukan'
    ]);

}

$description = $activity->description;

if ($bmi >= 40) {

    $activity->duration_minutes = 10;

    $description .=
        "\n\nBMI sangat tinggi. Mulailah perlahan.";

}
elseif ($bmi >= 35) {

    $activity->duration_minutes = 15;

}
elseif ($bmi >= 30) {

    $activity->duration_minutes = 20;

}
elseif ($bmi >= 25) {

    $activity->duration_minutes = 25;

}
else {

    $activity->duration_minutes += 5;

}

if (str_contains($risk, 'high')) {

    $description .=
        "\n\n• Lakukan pemanasan minimal 10 menit.";

}

if (str_contains($risk, 'very')) {

    $description .=
        "\n• Mulai dari intensitas rendah.";

}

if (str_contains($risk, 'normal')) {

    $description .=
        "\n• Pertahankan aktivitas secara konsisten.";

}

$activity->description = $description;

        return response()->json([
            'success'=>true,
            'data'=>$activity
        ]);
    }
}
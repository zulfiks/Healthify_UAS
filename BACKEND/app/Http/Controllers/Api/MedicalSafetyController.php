<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Screening;
use App\Services\MedicalSafetyService;

class MedicalSafetyController extends Controller
{
    public function analyze(
        $user_id,
        MedicalSafetyService $service
    ) {

        $screening = Screening::where(
            'user_id',
            $user_id
        )->latest()->first();

        if (!$screening) {

            return response()->json([
                'success' => false,
                'message' => 'Screening tidak ditemukan'
            ]);

        }

        $result = $service->analyze(
            $screening
        );

        return response()->json([

            'success' => true,

            'data' => [

                'safety_status' =>
                    $this->extractSection(
                        $result,
                        'Safety Status:'
                    ),

                'risk_factors' =>
                    $this->extractSection(
                        $result,
                        'Risk Factors:'
                    ),

                'exercise_advice' =>
                    $this->extractSection(
                        $result,
                        'Exercise Advice:'
                    ),

                'medical_recommendation' =>
                    $this->extractSection(
                        $result,
                        'Medical Recommendation:'
                    ),

                'raw_text' => $result

            ]

        ]);

    }

    private function extractSection(
        $text,
        $keyword
    ) {

        if (
            !str_contains(
                $text,
                $keyword
            )
        ) {

            return "-";

        }

        $start =
            strpos(
                $text,
                $keyword
            )
            +
            strlen(
                $keyword
            );

        $end =
            strlen(
                $text
            );

        $keywords = [

            'Safety Status:',
            'Risk Factors:',
            'Exercise Advice:',
            'Medical Recommendation:'

        ];

        foreach ($keywords as $k) {

            if ($k == $keyword) {

                continue;

            }

            $pos =
                strpos(
                    $text,
                    $k,
                    $start
                );

            if (
                $pos !== false
                &&
                $pos < $end
            ) {

                $end = $pos;

            }

        }

        return trim(
            substr(
                $text,
                $start,
                $end - $start
            )
        );

    }
}
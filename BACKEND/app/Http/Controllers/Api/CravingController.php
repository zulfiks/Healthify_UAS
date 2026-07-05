<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CravingHistory;
use App\Models\Screening;
use App\Services\CravingSupportService;

class CravingController extends Controller
{
    public function store(
        $user_id,
        $type,
        CravingSupportService $service
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

        $result = $service->generate(
            $type,
            $screening
        );

        $history = CravingHistory::create([

            'user_id' => $user_id,

            'craving_type' => $type,

            'message' => $type,

            'ai_response' => $result

        ]);

        return response()->json([

            'success' => true,

            'data' => [

                'delay_technique' => $this->extractSection(
                    $result,
                    'Delay Technique:'
                ),

                'healthy_snack' => $this->extractSection(
                    $result,
                    'Healthy Snack:'
                ),

                'motivation' => $this->extractSection(
                    $result,
                    'Short Motivation:'
                ),

                'activity' => $this->extractSection(
                    $result,
                    'Distraction Activity:'
                ),

                'ai_response' => $result

            ]

        ]);
    }

    public function history(
        $user_id
    ) {

        return response()->json([

            'success' => true,

            'data' => CravingHistory::where(
                'user_id',
                $user_id
            )
            ->latest()
            ->get()

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

        $end = strlen(
            $text
        );

        $keywords = [

            'Delay Technique:',
            'Healthy Snack:',
            'Short Motivation:',
            'Distraction Activity:'

        ];

        foreach ($keywords as $k) {

            if ($k == $keyword) {

                continue;

            }

            $pos = strpos(
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
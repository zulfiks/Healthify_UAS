<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Screening;
use App\Services\MealSwapService;

class MealSwapController extends Controller
{
    public function getRecommendation(
        $user_id,
        $food,
        MealSwapService $service
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

        $result = $service->recommend(
            $food,
            $screening
        );

        return response()->json([

            'success' => true,

            'data' => [

                'current_food' => $this->extractSection(
                    $result,
                    'Current Food:'
                ),

                'healthy_alternative' => $this->extractSection(
                    $result,
                    'Healthy Alternative:'
                ),

                'reason' => $this->extractSection(
                    $result,
                    'Reason:'
                ),

                'extra_tip' => $this->extractSection(
                    $result,
                    'Extra Tip:'
                ),

                'swap_recommendation' =>

                    "🥗 Alternatif:\n\n"

                    .

                    $this->extractSection(
                        $result,
                        'Healthy Alternative:'
                    )

                    .

                    "\n\n💡 Alasan:\n\n"

                    .

                    $this->extractSection(
                        $result,
                        'Reason:'
                    )

                    .

                    "\n\n⭐ Tips:\n\n"

                    .

                    $this->extractSection(
                        $result,
                        'Extra Tip:'
                    )

            ]

        ]);
    }

    private function extractSection(
        $text,
        $keyword
    ) {

        if (!str_contains(
            $text,
            $keyword
        )) {

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

            'Current Food:',
            'Healthy Alternative:',
            'Reason:',
            'Extra Tip:'

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
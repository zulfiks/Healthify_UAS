<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Screening;
use App\Services\BehaviorCoachingService;

class CoachingController extends Controller
{
    public function daily(
    int $user_id,
    BehaviorCoachingService $service
)
{

    $screening = Screening::where(
        'user_id',
        $user_id
    )->latest()->first();

    if (!$screening) {

        return response()->json([
            'success' => false,
            'message' => 'Belum melakukan screening'
        ]);
    }

    $result = $service->generate(
        $screening
    );

    return response()->json([
        'success' => true,
        'data' => [

            'motivation' => $this->extractSection(
                $result,
                'Daily Motivation:'
            ),

            'habit_evaluation' => $this->extractSection(
                $result,
                'Habit Evaluation:'
            ),

            'overeating_strategy' => $this->extractSection(
                $result,
                'Overeating Strategy:'
            ),

            'mindful_eating' => $this->extractSection(
                $result,
                'Mindful Eating:'
            ),

            'craving_support' => $this->extractSection(
                $result,
                'Craving Support:'
            ),

        ]
    ]);

}

    public function history(
        int $user_id
    ) {

        $screening = Screening::where(
            'user_id',
            $user_id
        )->latest()->first();

        if (!$screening) {

            return response()->json([
                'success' => false,
                'data' => []
            ]);
        }

        return response()->json([
            'success' => true,
            'data' => [
                [
                    'raw_text' =>
                        app(
                            BehaviorCoachingService::class
                        )->generate(
                            $screening
                        )
                ]
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

    $start = strpos(
        $text,
        $keyword
    ) + strlen(
        $keyword
    );

    $end = strlen(
        $text
    );

    $keywords = [

        'Daily Motivation:',
        'Habit Evaluation:',
        'Overeating Strategy:',
        'Mindful Eating:',
        'Craving Support:'

    ];

    foreach ($keywords as $k) {

        if ($k == $keyword) continue;

        $pos = strpos(
            $text,
            $k,
            $start
        );

        if (
            $pos !== false &&
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
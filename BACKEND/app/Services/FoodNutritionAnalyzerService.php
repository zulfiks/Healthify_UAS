<?php

namespace App\Services;

class FoodNutritionAnalyzerService
{
    public function analyze(array $foods): array
    {
        $result = [];

        foreach ($foods as $food) {

            $calories = (float) ($food['calories'] ?? 0);
            $protein  = (float) ($food['protein'] ?? 0);
            $carbs    = (float) ($food['carbs'] ?? 0);
            $fat       = (float) ($food['fat'] ?? 0);

            $risk = "Low";
            $reason = [];
            $needSwap = false;

            /*
            |--------------------------------------------------------------------------
            | Calories
            |--------------------------------------------------------------------------
            */

            if ($calories >= 700) {

                $risk = "High";
                $needSwap = true;

                $reason[] =
                    "Kalori makanan cukup tinggi.";

            } elseif ($calories >= 500) {

                $risk = "Medium";

                $reason[] =
                    "Kalori makanan tergolong sedang.";

            }

            /*
            |--------------------------------------------------------------------------
            | Fat
            |--------------------------------------------------------------------------
            */

            if ($fat >= 25) {

                $risk = "High";
                $needSwap = true;

                $reason[] =
                    "Lemak cukup tinggi.";

            }

            /*
            |--------------------------------------------------------------------------
            | Protein
            |--------------------------------------------------------------------------
            */

            if ($protein >= 25) {

                $reason[] =
                    "Protein tinggi sehingga membantu rasa kenyang.";

            }

            /*
            |--------------------------------------------------------------------------
            | Carbohydrate
            |--------------------------------------------------------------------------
            */

            if ($carbs >= 65) {

                $reason[] =
                    "Karbohidrat cukup tinggi.";

            }

            /*
            |--------------------------------------------------------------------------
            | Final
            |--------------------------------------------------------------------------
            */

            $food['nutrition_analysis'] = [

                'risk' => $risk,

                'need_swap' => $needSwap,

                'reason' => implode(
                    ' ',
                    $reason
                )

            ];

            $result[] = $food;

        }

        return $result;
    }
}
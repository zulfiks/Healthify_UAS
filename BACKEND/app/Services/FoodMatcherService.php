<?php

namespace App\Services;

use App\Models\Food;

class FoodMatcherService
{
    public function matchFoods(array $foods): array
    {
        $matchedFoods = [];

        foreach ($foods as $food) {

            $keyword = trim($food['food_name']);

            // Exact Match
            $dbFood = Food::where('name', $keyword)->first();

            // LIKE Match
            if (!$dbFood) {
                $dbFood = Food::where(
                    'name',
                    'LIKE',
                    "%{$keyword}%"
                )->first();
            }

            // Reverse LIKE
            if (!$dbFood) {
                $dbFood = Food::whereRaw(
                    "? LIKE CONCAT('%',name,'%')",
                    [$keyword]
                )->first();
            }

            if ($dbFood) {

                $food['database_match'] = true;

                $food['food_id'] = $dbFood->id;

                $food['database_name'] = $dbFood->name;

                $food['calories'] = $dbFood->calories;

                $food['protein'] = $dbFood->protein;

                $food['carbs'] = $dbFood->carbs;

                $food['fat'] = $dbFood->fat;

                $food['serving_size'] = $dbFood->serving_size;

            } else {

                $food['database_match'] = false;

                $food['food_id'] = null;

            }

            $matchedFoods[] = $food;
        }

        return $matchedFoods;
    }
}
<?php

namespace App\Services;

class PortionEstimatorService
{

    public function estimate(
        array $foods
    ): array
    {

        $result = [];

        foreach ($foods as $food) {

            $portion =
                strtolower(
                    $food['portion'] ?? ''
                );

            $unit =
                strtolower(
                    $food['unit'] ?? ''
                );

            $weight = '';

            $calories = '';

            $confidence = 'Medium';
            /*
|--------------------------------------------------------------------------
| Jika makanan ditemukan di database
|--------------------------------------------------------------------------
*/

if (
    isset($food['database_match']) &&
    $food['database_match'] &&
    isset($food['calories'])
) {

    $baseCalories = (float)$food['calories'];

    $portion = strtolower($food['portion'] ?? '');

    if ($portion == 'kecil') {

        $estimatedCalories = round($baseCalories * 0.75);

    } elseif ($portion == 'besar') {

        $estimatedCalories = round($baseCalories * 1.25);

    } elseif ($portion == '2') {

        $estimatedCalories = round($baseCalories * 2);

    } else {

        $estimatedCalories = round($baseCalories);

    }

    $food['estimated_calories']
        = $estimatedCalories . ' kcal';

    $food['estimated_weight']
        = $food['serving_size'];

    $food['confidence']
        = 'Very High';

    $result[] = $food;

    continue;

}

            // =========================
            // PORSI
            // =========================

            if ($portion == 'kecil') {

                $weight = '150-200 gram';

                $calories = '250-350 kcal';

            }

            elseif ($portion == 'sedang') {

                $weight = '250-300 gram';

                $calories = '450-600 kcal';

            }

            elseif ($portion == 'besar') {

                $weight = '350-450 gram';

                $calories = '650-850 kcal';

            }

            elseif ($portion == '1'
                && $unit == 'mangkuk') {

                $weight = '250-350 gram';

                $calories = '350-500 kcal';

            }

            elseif ($portion == '1'
                && $unit == 'gelas') {

                $weight = '200-250 ml';

                $calories = '80-180 kcal';

            }

            elseif ($portion == '2') {

                $weight = '500-700 gram';

                $calories = '900-1200 kcal';

            }

            else {

                $weight = 'Tidak diketahui';

                $calories = 'Tidak diketahui';

                $confidence = 'Low';

            }

            $food['estimated_weight']
                = $weight;

            $food['estimated_calories']
                = $calories;

            $food['confidence']
                = $confidence;

            $result[] = $food;

        }

        return $result;

    }

}
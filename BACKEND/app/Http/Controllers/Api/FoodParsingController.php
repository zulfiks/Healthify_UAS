<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\FoodParsingService;
use App\Services\PortionEstimatorService;
use App\Services\FoodNutritionAnalyzerService;
use App\Services\FoodMatcherService;
use App\Services\MealSwapService;
use App\Models\Screening;
use App\Services\ImageRecognitionService;


class FoodParsingController extends Controller
{
    protected FoodParsingService $parser;
protected FoodMatcherService $matcher;
    protected PortionEstimatorService $estimator;
    protected FoodNutritionAnalyzerService $nutritionAnalyzer;
    protected MealSwapService $mealSwap;
protected ImageRecognitionService $imageService;

    public function __construct(
        FoodParsingService $parser,
        PortionEstimatorService $estimator,
        FoodMatcherService $matcher,
        FoodNutritionAnalyzerService $nutritionAnalyzer,
        MealSwapService $mealSwap,
        ImageRecognitionService $imageService
    ) {

        $this->parser = $parser;

        $this->estimator = $estimator;
        $this->matcher = $matcher;
        $this->nutritionAnalyzer = $nutritionAnalyzer;
        $this->mealSwap = $mealSwap;
        $this->imageService = $imageService;

    }

    public function parse(
        Request $request
    ) {

        $request->validate([
    'user_id' => 'required|integer|exists:users,id',
    'text' => 'required|string'
]);

        $parsed = $this->parser
            ->parse(
                $request->text
            );

        if (!$parsed['success']) {

            return response()->json([

                'success' => false,

                'message' => $parsed['message'],

                'raw' => $parsed['raw']

            ], 422);

        }

    $foods = $this->matcher
    ->matchFoods(
        $parsed['foods']
    );

    $foods = $this->estimator
        ->estimate(
            $foods
        );

    $foods = $this->nutritionAnalyzer
        ->analyze($foods);
$userId = $request->input('user_id');

$screening = Screening::where('user_id', $userId)
    ->latest()
    ->first();

foreach ($foods as &$food) {

    if (
        isset($food['nutrition_analysis']['need_swap']) &&
        $food['nutrition_analysis']['need_swap'] &&
        $screening
    ) {

        $food['meal_swap'] =
            $this->mealSwap
                ->recommend(
                    $food,
                    $screening
                );

    }

}        

        return response()->json([

            'success' => true,

            'foods' => $foods

        ]);

    }
    public function parseImage(Request $request)
{
    $request->validate([
        'image' => 'required|image|max:5120'
    ]);

    $base64 = base64_encode(file_get_contents($request->file('image')->getRealPath()));

    $text = $this->imageService->recognize($base64);

    if (!$text) {
        return response()->json([
            'success' => false,
            'message' => 'Gagal mengenali gambar.'
        ], 422);
    }

    return response()->json([
        'success' => true,
        'text' => $text
    ]);
}
}
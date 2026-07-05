class FoodAIResponse {
  final bool success;
  final List<FoodAIItem> foods;

  FoodAIResponse({
    required this.success,
    required this.foods,
  });

  factory FoodAIResponse.fromJson(Map<String, dynamic> json) {
    return FoodAIResponse(
      success: json['success'] ?? false,
      foods: (json['foods'] as List)
          .map((e) => FoodAIItem.fromJson(e))
          .toList(),
    );
  }
}

class FoodAIItem {
  final String foodName;
  final String portion;
  final String unit;

  final bool databaseMatch;

  final int? foodId;

  final String databaseName;

  final int calories;

  final double protein;

  final double carbs;

  final double fat;

  final String servingSize;

  final String estimatedCalories;

  final String estimatedWeight;

  final String confidence;

  final NutritionAnalysis nutrition;

  final MealSwap mealSwap;

  FoodAIItem({
    required this.foodName,
    required this.portion,
    required this.unit,
    required this.databaseMatch,
    required this.foodId,
    required this.databaseName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.estimatedCalories,
    required this.estimatedWeight,
    required this.confidence,
    required this.nutrition,
    required this.mealSwap,
  });

  factory FoodAIItem.fromJson(Map<String, dynamic> json) {
    return FoodAIItem(
      foodName: json['food_name'] ?? '',
      portion: json['portion'] ?? '',
      unit: json['unit'] ?? '',
      databaseMatch: json['database_match'] ?? false,
      foodId: json['food_id'],
      databaseName: json['database_name'] ?? '',
      calories: json['calories'] ?? 0,
      protein: double.tryParse(json['protein'].toString()) ?? 0,
      carbs: double.tryParse(json['carbs'].toString()) ?? 0,
      fat: double.tryParse(json['fat'].toString()) ?? 0,
      servingSize: json['serving_size'] ?? '',
      estimatedCalories: json['estimated_calories'] ?? '',
      estimatedWeight: json['estimated_weight'] ?? '',
      confidence: json['confidence'] ?? '',
      nutrition:
          NutritionAnalysis.fromJson(json['nutrition_analysis'] ?? {}),
      mealSwap: json['meal_swap'] != null
          ? MealSwap.fromJson(json['meal_swap'])
          : MealSwap.empty(),
    );
  }
}

class NutritionAnalysis {
  final String risk;
  final bool needSwap;
  final String reason;

  NutritionAnalysis({
    required this.risk,
    required this.needSwap,
    required this.reason,
  });

  factory NutritionAnalysis.fromJson(Map<String, dynamic> json) {
    return NutritionAnalysis(
      risk: json['risk'] ?? '',
      needSwap: json['need_swap'] ?? false,
      reason: json['reason'] ?? '',
    );
  }
}

class MealSwap {
  final String currentFood;

  final String healthyAlternative;

  final String reason;

  final String extraTip;

  MealSwap({
    required this.currentFood,
    required this.healthyAlternative,
    required this.reason,
    required this.extraTip,
  });

  factory MealSwap.fromJson(Map<String, dynamic> json) {
    return MealSwap(
      currentFood: json['current_food'] ?? '',
      healthyAlternative: json['healthy_alternative'] ?? '',
      reason: json['reason'] ?? '',
      extraTip: json['extra_tip'] ?? '',
    );
  }

  factory MealSwap.empty() {
    return MealSwap(
      currentFood: '',
      healthyAlternative: '',
      reason: '',
      extraTip: '',
    );
  }
}
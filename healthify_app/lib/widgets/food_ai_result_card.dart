import 'package:flutter/material.dart';

import '../models/food_ai_model.dart';
import 'nutrition_card.dart';
import 'meal_swap_card.dart';

class FoodAIResultCard extends StatelessWidget {
  final FoodAIResponse response;

  const FoodAIResultCard({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    if (response.foods.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text("Tidak ada makanan terdeteksi."),
          ),
        ),
      );
    }

    return Column(
      children: response.foods.map((food) {
        return Card(
          margin: const EdgeInsets.only(bottom: 18),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    const CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.restaurant),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            food.foodName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "${food.estimatedCalories} • ${food.servingSize}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                NutritionCard(food: food),

                const SizedBox(height: 20),

                if (food.nutrition.needSwap)
                  MealSwapCard(
                    mealSwap: food.mealSwap,
                  ),

              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
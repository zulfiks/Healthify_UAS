import 'package:flutter/material.dart';

import '../models/food_ai_model.dart';

class NutritionCard extends StatelessWidget {
  final FoodAIItem food;

  const NutritionCard({
    super.key,
    required this.food,
  });

  Color _riskColor() {
    switch (food.nutrition.risk.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _riskIcon() {
    switch (food.nutrition.risk.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info;
      default:
        return Icons.check_circle;
    }
  }

  Widget _buildItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [

            Icon(
              icon,
              color: color,
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          "Informasi Nutrisi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [

            _buildItem(
              Icons.local_fire_department,
              "Kalori",
              "${food.calories}",
              Colors.orange,
            ),

            const SizedBox(width: 10),

            _buildItem(
              Icons.fitness_center,
              "Protein",
              "${food.protein} g",
              Colors.blue,
            ),

          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [

            _buildItem(
              Icons.rice_bowl,
              "Karbo",
              "${food.carbs} g",
              Colors.green,
            ),

            const SizedBox(width: 10),

            _buildItem(
              Icons.water_drop,
              "Lemak",
              "${food.fat} g",
              Colors.purple,
            ),

          ],
        ),

        const SizedBox(height: 18),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _riskColor().withOpacity(.08),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Icon(
                _riskIcon(),
                color: _riskColor(),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Risk : ${food.nutrition.risk}",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color: _riskColor(),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      food.nutrition.reason.isEmpty
                          ? "Makanan ini cukup aman dikonsumsi."
                          : food.nutrition.reason,
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),

      ],
    );
  }
}
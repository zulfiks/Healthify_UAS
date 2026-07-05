import 'package:flutter/material.dart';

import '../models/food_ai_model.dart';

class MealSwapCard extends StatelessWidget {
  final MealSwap mealSwap;

  const MealSwapCard({
    super.key,
    required this.mealSwap,
  });

  @override
  Widget build(BuildContext context) {

    if (mealSwap.healthyAlternative.isEmpty) {
      return const SizedBox();
    }

    return Card(
      elevation: 0,
      color: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
  color: Color(0xFFC7F464),
  width: 1.2,
),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              children: const [

Icon(
  Icons.swap_horiz_rounded,
  color: Color(0xFFC7F464),
  size: 26,
),

                SizedBox(width: 8),

                Text(
  "Healthy Meal Swap",
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  ),
),

              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Alternatif yang Direkomendasikan",
              style: TextStyle(
  color: Colors.white70,
  fontWeight: FontWeight.bold,
),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
  color: const Color(0xFF252525),
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
    color: const Color(0xFFC7F464).withOpacity(0.25),
    width: 1,
  ),
),
              child: Text(
                mealSwap.healthyAlternative,
                style: TextStyle(
  color: Color(0xFFC7F464),
  fontWeight: FontWeight.bold,
  fontSize: 17,
),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Mengapa disarankan?",
              style: TextStyle(
  color: Colors.white70,
  fontWeight: FontWeight.bold,
),
            ),

            const SizedBox(height: 6),

            Text(
  mealSwap.reason,
  style: const TextStyle(
    color: Colors.white70,
    height: 1.5,
  ),
),

            const SizedBox(height: 18),

Divider(
  thickness: 0.8,
  color: Colors.white.withOpacity(0.08),
),

            const SizedBox(height: 10),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Icon(
  Icons.lightbulb_rounded,
  color: Color(0xFFFFC107),
  size: 22,
),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
  mealSwap.extraTip,
  style: const TextStyle(
    color: Colors.white70,
    height: 1.5,
  ),
),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
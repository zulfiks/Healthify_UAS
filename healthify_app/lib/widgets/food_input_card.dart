import 'package:flutter/material.dart';

class FoodInputCard extends StatelessWidget {
  final TextEditingController controller;

  final VoidCallback onAnalyze;

  final bool loading;

  const FoodInputCard({
    super.key,
    required this.controller,
    required this.onAnalyze,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "🤖 AI Food Analysis",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Ceritakan makanan yang kamu konsumsi hari ini.",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Contoh:\nAku makan nasi padang porsi sedang dan es teh manis satu gelas.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: loading ? null : onAnalyze,
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  loading
                      ? "Menganalisis..."
                      : "Analisis dengan AI",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
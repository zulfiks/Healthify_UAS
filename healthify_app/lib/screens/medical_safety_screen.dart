import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MedicalSafetyScreen extends StatefulWidget {
  final int userId;

  const MedicalSafetyScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MedicalSafetyScreen> createState() =>
      _MedicalSafetyScreenState();
}

class _MedicalSafetyScreenState
    extends State<MedicalSafetyScreen> {

  bool isLoading = true;

  String safetyStatus = "-";
  String riskFactors = "-";
  String exerciseAdvice = "-";
  String medicalRecommendation = "-";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final response =
        await ApiService.getMedicalSafety(
      widget.userId,
    );

    if (response != null) {

      final data = response['data'];

      setState(() {

        safetyStatus =
            data['safety_status'] ?? "-";

        riskFactors =
            data['risk_factors'] ?? "-";

        exerciseAdvice =
            data['exercise_advice'] ?? "-";

        medicalRecommendation =
            data['medical_recommendation'] ?? "-";

        isLoading = false;

      });

    }
  }

  Widget buildCard(
      IconData icon,
      Color color,
      String title,
      String content) {

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              CircleAvatar(
                backgroundColor:
                    color.withOpacity(0.15),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        title: const Text(
          "Medical Safety",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                children: [

                  buildCard(
                    Icons.warning_amber,
                    Colors.redAccent,
                    "Safety Status",
                    safetyStatus,
                  ),

                  buildCard(
                    Icons.error_outline,
                    Colors.orange,
                    "Risk Factors",
                    riskFactors,
                  ),

                  buildCard(
                    Icons.directions_run,
                    Colors.blue,
                    "Exercise Advice",
                    exerciseAdvice,
                  ),

                  buildCard(
                    Icons.medical_services,
                    Colors.green,
                    "Medical Recommendation",
                    medicalRecommendation,
                  ),
                ],
              ),
            ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CravingScreen extends StatefulWidget {
  final int userId;

  const CravingScreen({
    super.key,
    required this.userId,
  });

  @override
  State<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends State<CravingScreen> {

  String response = '';
  bool isLoading = false;

  Future<void> getResponse(String type) async {

    setState(() {
      isLoading = true;
    });

    try {

      final result =
          await ApiService.sendCraving(widget.userId, type);

      setState(() {
        response =
            result['data']['ai_response'] ?? '';
      });

    } catch (e) {

      setState(() {
        response =
            'Gagal mengambil saran AI.';
      });

    }

    setState(() {
      isLoading = false;
    });
  }

  Widget cravingButton({
    required String emoji,
    required String title,
    required String type,
  }) {

    return GestureDetector(

      onTap: () {
        getResponse(type);
      },

      child: Container(

        margin: const EdgeInsets.only(bottom: 15),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFC7F464).withValues(alpha: 0.2),
          ),
        ),

        child: Row(

          children: [

            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFC7F464),
              size: 18,
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "⚡ Craving Emergency",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: const Color(0xFF114232),
                borderRadius: BorderRadius.circular(24),
              ),

              child: const Column(

                children: [

                  Icon(
                    Icons.health_and_safety,
                    color: Color(0xFFC7F464),
                    size: 60,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Butuh bantuan mengendalikan craving?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Healthify AI akan memberikan intervensi cepat agar kamu tidak makan berlebihan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            cravingButton(
              emoji: "🥤",
              title: "Ingin Minuman Manis",
              type: "sweet_drink",
            ),

            cravingButton(
              emoji: "🍔",
              title: "Ingin Fast Food",
              type: "fast_food",
            ),

            cravingButton(
              emoji: "🌙",
              title: "Lapar Tengah Malam",
              type: "night_snack",
            ),

            cravingButton(
              emoji: "😥",
              title: "Stress Eating",
              type: "stress_eating",
            ),

            const SizedBox(height: 25),

            if (isLoading)

              const CircularProgressIndicator(
                color: Color(0xFFC7F464),
              ),

            if (response.isNotEmpty)

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF114232),
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Row(
                      children: [

                        Icon(
                          Icons.psychology,
                          color: Color(0xFFC7F464),
                        ),

                        SizedBox(width: 10),

                        Text(
                          "AI Coaching Response",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )

                      ],
                    ),

                    SizedBox(height: 15),

                    Text(
                      response,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    )

                  ],
                ),
              )

          ],
        ),
      ),
    );
  }
}
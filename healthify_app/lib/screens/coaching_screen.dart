import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CoachingScreen extends StatefulWidget {
  final int userId;

  const CoachingScreen({
    super.key,
    required this.userId,
  });

  @override
  State<CoachingScreen> createState() => _CoachingScreenState();
}

class _CoachingScreenState extends State<CoachingScreen> {
  bool isLoading = true;

  String motivation = "";
  String habitEvaluation = "";
  String overeatingStrategy = "";
  String mindfulEating = "";
  String cravingSupport = "";

  @override
  void initState() {
    super.initState();
    loadCoaching();
  }

  Future<void> loadCoaching() async {
    setState(() {
      isLoading = true;
    });

    final result =
        await ApiService.getDailyCoaching(widget.userId);

    if (result != null) {
      setState(() {
        motivation = result["motivation"] ?? "-";
        habitEvaluation =
            result["habit_evaluation"] ?? "-";
        overeatingStrategy =
            result["overeating_strategy"] ?? "-";
        mindfulEating =
            result["mindful_eating"] ?? "-";
        cravingSupport =
            result["craving_support"] ?? "-";

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xff161616);
  final Color lime = const Color(0xffC7F464);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: lime,
                ),
              )
            : RefreshIndicator(
                color: lime,
                onRefresh: loadCoaching,
                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            borderRadius:
                                BorderRadius.circular(100),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration:
                                  const BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Behavior Change\nCoaching",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 12),

                                Text(
                                  "AI coach untuk membantu perubahan gaya hidupmu.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    height: 1.5,
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(
                            width: 100,
                            height: 100,
                            decoration:
                                BoxDecoration(
                              color: const Color(0xff114232),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.psychology,
                              size: 50,
                              color: Color(0xffC7F464),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 30),

                      buildCard(
                        "🌞 Daily Motivation",
                        motivation,
                        Colors.orange,
                      ),

                      buildCard(
                        "🔍 Habit Evaluation",
                        habitEvaluation,
                        Colors.cyan,
                      ),

                      buildCard(
                        "🍔 Overeating Strategy",
                        overeatingStrategy,
                        Colors.pinkAccent,
                      ),

                      buildCard(
                        "🧠 Mindful Eating",
                        mindfulEating,
                        Colors.purpleAccent,
                      ),

                      buildCard(
                        "❤️ Craving Support",
                        cravingSupport,
                        Colors.redAccent,
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xff114232),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [

                            Icon(
                              Icons.auto_awesome,
                              color: lime,
                              size: 35,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Powered by Healthify AI",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Llama 3.3 via Groq",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: loadCoaching,
                          icon:
                              const Icon(Icons.refresh),
                          label: const Text(
                            "Generate Again",
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: lime,
                            foregroundColor:
                                Colors.black,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildCard(
      String title,
      String content,
      Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              height: 1.7,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
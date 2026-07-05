import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WeightLossPlanScreen extends StatefulWidget {
  final int userId;

  const WeightLossPlanScreen({
    super.key,
    required this.userId,
  });

  @override
  State<WeightLossPlanScreen> createState() =>
      _WeightLossPlanScreenState();
}

class _WeightLossPlanScreenState
    extends State<WeightLossPlanScreen> {
  bool isLoading = true;

  String focus = "";
  String activityTarget = "";
  String smallHabit = "";
  String menuRecommendation = "";

  @override
  void initState() {
    super.initState();
    loadPlan();
  }

 Future<void> loadPlan() async {
  try {
    setState(() {
      isLoading = true;
    });

    print("=== LOAD PLAN ===");

    final response =
        await ApiService.getWeightLossPlan(widget.userId);


    if (response != null && response['success'] == true) {

      final String plan = response['plan'] ?? "";

      focus = _extractSection(plan, "Focus:");
      activityTarget =
          _extractSection(plan, "Activity Target:");
      smallHabit =
          _extractSection(plan, "Small Habit:");
      menuRecommendation =
          _extractSection(plan, "Menu Recommendation:");
          print(response);
print("Focus : $focus");
print("Activity : $activityTarget");
print("Habit : $smallHabit");
print("Menu : $menuRecommendation");
    }
    

  } catch (e, s) {
    print(e);
    print(s);
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  String _extractSection(
    String text,
    String keyword,
) {
    if (!text.contains(keyword)) return "-";

    int start = text.indexOf(keyword) + keyword.length;

    int end = text.length;

    List<String> keywords = [
      "Focus:",
      "Activity Target:",
      "Small Habit:",
      "Menu Recommendation:"
    ];

    for (String k in keywords) {
      if (k == keyword) continue;

      int idx = text.indexOf(k, start);

      if (idx != -1 && idx < end) {
        end = idx;
      }
    }

    return text.substring(start, end).trim();
  }

  Widget buildCard(
    IconData icon,
    Color color,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
              ],
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
        centerTitle: true,
        title: const Text(
          "AI Personal Plan",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xffC7F464),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xffC7F464),
              onRefresh: loadPlan,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff4DB6AC),
                          Color(0xff2E7D73),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                    child: const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xffC7F464),
                          size: 40,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "AI Personal\nWeight Loss Plan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Generated by Healthify AI",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  buildCard(
                    Icons.flag,
                    const Color(0xffC7F464),
                    "Focus",
                    focus,
                  ),

                  buildCard(
                    Icons.directions_run,
                    Colors.orange,
                    "Activity Target",
                    activityTarget,
                  ),

                  buildCard(
                    Icons.lightbulb,
                    Colors.cyan,
                    "Small Habit",
                    smallHabit,
                  ),

                  buildCard(
                    Icons.restaurant,
                    Colors.pinkAccent,
                    "Menu Recommendation",
                    menuRecommendation,
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: Colors.green.shade300,
                          size: 35,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Powered by Healthify AI\nLlama 3.3 via Groq",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xffC7F464),
                      foregroundColor: Colors.black,
                      minimumSize:
                          const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: loadPlan,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      "Generate Again",
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
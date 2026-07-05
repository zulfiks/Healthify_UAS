import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FoodHistoryScreen extends StatefulWidget {
  final int userId;

  const FoodHistoryScreen({
    super.key,
    required this.userId,
  });

  @override
  State<FoodHistoryScreen> createState() => _FoodHistoryScreenState();
}

class _FoodHistoryScreenState extends State<FoodHistoryScreen> {
  List<dynamic> histories = [];
  bool isLoading = true;

  final Color darkBg = const Color(0xFF000000);
  final Color cardColor = const Color(0xFF161616);
  final Color darkGreen = const Color(0xFF054A3B);
  final Color limeGreen = const Color(0xFFD2F564);
  final Color lightBlue = const Color(0xFF4AC2C5);
  final Color peach = const Color(0xFFF7B19C);

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final data = await ApiService.getFoodHistory(widget.userId);

    if (mounted) {
      setState(() {
        histories = data;
        isLoading = false;
      });
    }
  }

  IconData getFoodIcon(String foodName) {
    String food = foodName.toLowerCase();

    if (food.contains('ayam')) return Icons.egg_alt;
    if (food.contains('nasi')) return Icons.rice_bowl;
    if (food.contains('bakso')) return Icons.lunch_dining;
    if (food.contains('mie')) return Icons.ramen_dining;
    if (food.contains('susu')) return Icons.local_drink;
    if (food.contains('buah')) return Icons.apple;
    if (food.contains('roti')) return Icons.bakery_dining;

    return Icons.fastfood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: peach.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -40,
            top: 250,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: lightBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Riwayat Makanan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Semua makanan yang pernah dicatat ✨",
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: limeGreen,
                          ),
                        )
                      : histories.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restaurant_menu,
                                    color: limeGreen,
                                    size: 80,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Belum ada riwayat makanan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Mulai catat makananmu hari ini 🍽",
                                    style: TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              color: limeGreen,
                              onRefresh: fetchHistory,
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                    24, 10, 24, 100),
                                itemCount: histories.length,
                                itemBuilder: (context, index) {
                                  final item = histories[index];

                                  String nama =
                                      item['food_name'] ?? "Makanan";
                                  String kalori =
                                      item['total_calories'].toString();
                                  String porsi =
                                      item['portion'].toString();
                                  String tanggal =
                                      item['log_date'].toString();

                                  return TweenAnimationBuilder(
                                    duration: Duration(
                                        milliseconds: 300 + index * 100),
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          40 * (1 - value),
                                        ),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 18),
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius:
                                            BorderRadius.circular(24),
                                        border: Border.all(
                                          color: Colors.white10,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: darkGreen,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Icon(
                                              getFoodIcon(nama),
                                              color: limeGreen,
                                              size: 34,
                                            ),
                                          ),

                                          const SizedBox(width: 18),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  nama,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(height: 10),

                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.local_fire_department,
                                                      size: 17,
                                                      color: limeGreen,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      "$kalori kkal",
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 5),

                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.restaurant,
                                                      color: Colors.white54,
                                                      size: 17,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      "$porsi porsi",
                                                      style: const TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 5),

                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.white54,
                                                      size: 17,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      tanggal,
                                                      style: const TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
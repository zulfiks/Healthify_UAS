import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> leaderboard = [];
  bool loading = true;
  String selectedLimit = "5";

  // --- UI COLORS CONSTANTS ---
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color inputColor = const Color(0xFF222222);
  final Color greenColor = const Color(0xFFC7F464);

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    setState(() {
      loading = true;
    });

    final data = await ApiService.getLeaderboard(
      selectedLimit,
    );

    if (!mounted) return;

    setState(() {
      leaderboard = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          
          // --- HEADER & FILTER CHIPS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: greenColor, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "Top Achievers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                buildChip("5"),
                const SizedBox(width: 10),
                buildChip("10"),
                const SizedBox(width: 10),
                buildChip("20"),
                const SizedBox(width: 10),
                buildChip("50"),
                const SizedBox(width: 10),
                buildChip("all"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- KONTEN LEADERBOARD ---
          Expanded(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(color: greenColor),
                  )
                : leaderboard.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: cardColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.format_list_numbered_rtl_rounded,
                                size: 48,
                                color: Colors.white24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Leaderboard Kosong",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        itemCount: leaderboard.length,
                        itemBuilder: (context, index) {
                          return buildLeaderboardCard(
                            leaderboard[index],
                            index,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // --- MODERN PILL CHIP ---
  Widget buildChip(String limit) {
    final isSelected = selectedLimit == limit;
    final label = limit == "all" ? "Semua" : "Top $limit";

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLimit = limit;
        });
        loadLeaderboard();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? greenColor : cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? greenColor : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // --- MODERN LEADERBOARD CARD ---
  Widget buildLeaderboardCard(Map<String, dynamic> user, int index) {
    bool isTop3 = index < 3;
    
    // Konfigurasi warna & icon untuk rank
    Color rankColor;
    Widget rankIcon;

    if (index == 0) {
      rankColor = Colors.amber;
      rankIcon = const Text("🥇", style: TextStyle(fontSize: 26));
    } else if (index == 1) {
      rankColor = Colors.grey.shade400;
      rankIcon = const Text("🥈", style: TextStyle(fontSize: 26));
    } else if (index == 2) {
      rankColor = Colors.orange.shade300;
      rankIcon = const Text("🥉", style: TextStyle(fontSize: 26));
    } else {
      rankColor = Colors.white24;
      rankIcon = Text(
        "${index + 1}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isTop3 ? rankColor.withOpacity(0.5) : Colors.white.withOpacity(0.05),
          width: isTop3 ? 1.5 : 1.0,
        ),
        // Glow effect halus untuk top 3
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: rankColor.withOpacity(0.08),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          // 1. Rank Indicator
          SizedBox(
            width: 40,
            child: Center(child: rankIcon),
          ),
          const SizedBox(width: 12),
          
          // 2. Avatar
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isTop3 ? rankColor : greenColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: inputColor,
              backgroundImage: user["profile_picture"] != null && user["profile_picture"].toString().isNotEmpty
                  ? NetworkImage(user["profile_picture"])
                  : null,
              child: user["profile_picture"] == null || user["profile_picture"].toString().isEmpty
                  ? const Icon(Icons.person_rounded, color: Colors.white54, size: 24)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          
          // 3. Name 
          Expanded(
            child: Text(
              user["name"]?.toString() ?? "-",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 10),
          
          // 4. Score XP 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: greenColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${user["skor"]} XP",
              style: TextStyle(
                color: greenColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
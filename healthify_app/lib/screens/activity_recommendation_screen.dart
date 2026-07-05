import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'activity_screen.dart';

class ActivityRecommendationScreen extends StatefulWidget {
  final int userId;

  const ActivityRecommendationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ActivityRecommendationScreen> createState() =>
      _ActivityRecommendationScreenState();
}

class _ActivityRecommendationScreenState extends State<ActivityRecommendationScreen> {
  Map<String, dynamic>? recommendation;
  bool loading = true;

  // --- UI COLORS CONSTANTS ---
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color inputColor = const Color(0xFF222222);
  final Color greenColor = const Color(0xFFC7F464);

  @override
  void initState() {
    super.initState();
    loadRecommendation();
  }

  Future<void> loadRecommendation() async {
    final result = await ApiService.getActivityRecommendation(
      widget.userId,
    );

    if (!mounted) return;

    setState(() {
      recommendation = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. LOADING STATE
    if (loading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(color: greenColor),
        ),
      );
    }

    // 2. EMPTY STATE
    if (recommendation == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Today's Activity",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
                child: const Icon(Icons.directions_run_rounded, size: 48, color: Colors.white24),
              ),
              const SizedBox(height: 20),
              const Text(
                "Belum ada rekomendasi",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Aktivitasmu untuk hari ini belum tersedia.",
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // 3. MAIN UI STATE
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Today's Activity",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            buildActivityCard(),
            const SizedBox(height: 20),
            buildReasonCard(),
            const SizedBox(height: 20),
            buildTipsCard(),
            const SizedBox(height: 20),
            buildTargetCard(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Pill Shape
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActivityScreen(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                label: const Text(
                  "Mulai Aktivitas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget buildActivityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: greenColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_run_rounded,
              size: 50,
              color: greenColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            recommendation!["activity_name"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: inputColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_rounded, size: 16, color: greenColor),
                const SizedBox(width: 8),
                Text(
                  "${recommendation!["duration_minutes"]} Menit",
                  style: TextStyle(
                    color: greenColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReasonCard() {
    return _buildModernInfoCard(
      title: "Mengapa direkomendasikan?",
      icon: Icons.lightbulb_outline_rounded,
      iconColor: Colors.amberAccent,
      child: Text(
        recommendation!["description"],
        style: const TextStyle(
          color: Colors.white70,
          height: 1.6,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildTipsCard() {
    return _buildModernInfoCard(
      title: "Tips Persiapan",
      icon: Icons.info_outline_rounded,
      iconColor: Colors.lightBlueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTipItem("Lakukan pemanasan 5 menit sebelum mulai"),
          _buildTipItem("Minum air putih sebelum dan sesudah olahraga"),
          _buildTipItem("Hentikan segera jika merasa pusing atau sakit"),
        ],
      ),
    );
  }

  Widget buildTargetCard() {
    return _buildModernInfoCard(
      title: "Target Minggu Ini",
      icon: Icons.flag_outlined,
      iconColor: Colors.orangeAccent,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: inputColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "3x",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Melakukan ${recommendation!["activity_name"]}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildModernInfoCard({required String title, required IconData icon, required Color iconColor, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: greenColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
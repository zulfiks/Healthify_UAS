import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ExpertReviewResultScreen extends StatefulWidget {
  final int userId;

  const ExpertReviewResultScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ExpertReviewResultScreen> createState() =>
      _ExpertReviewResultScreenState();
}

class _ExpertReviewResultScreenState extends State<ExpertReviewResultScreen> {
  Map<String, dynamic>? review;
  bool loading = true;

  // --- UI COLORS CONSTANTS ---
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color inputColor = const Color(0xFF222222);
  final Color greenColor = const Color(0xFFC7F464);

  @override
  void initState() {
    super.initState();
    loadReview();
  }

  Future<void> loadReview() async {
    final data = await ApiService.getUserExpertReview(widget.userId);

    if (!mounted) return;

    setState(() {
      review = data;
      loading = false;
    });
  }

  // Helper untuk warna status
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "approved":
        return Colors.greenAccent;
      case "revised":
        return Colors.orangeAccent;
      case "pending":
        return Colors.lightBlueAccent;
      default:
        return Colors.white54;
    }
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

    // 2. EMPTY STATE (Belum direview)
    if (review == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Review Result",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: Center(
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
                  Icons.hourglass_empty_rounded,
                  size: 48,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Belum Direview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ahli gizi belum memberikan review\nuntuk profil Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. MAIN UI STATE (Ada Review)
    final statusColor = _getStatusColor(review!["status"]?.toString());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Review Result",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: EXPERT PROFILE & STATUS ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      (review!["status"]?.toString() ?? "Unknown").toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Expert Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: greenColor, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: inputColor,
                      child: Icon(
                        Icons.medical_services_rounded,
                        size: 40,
                        color: greenColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Expert Name
                  const Text(
                    "Direview oleh",
                    style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review!["expert_name"] ?? "Ahli Gizi",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- SECTION: CATATAN AHLI ---
            _buildInfoCard(
              title: "Catatan Ahli",
              content: review!["expert_note"] ?? "-",
              icon: Icons.notes_rounded,
              iconColor: Colors.blueAccent,
            ),
            const SizedBox(height: 16),

            // --- SECTION: MEAL PLAN ---
            _buildInfoCard(
              title: "Meal Plan Recommendation",
              content: review!["meal_plan"] ?? "-",
              icon: Icons.restaurant_menu_rounded,
              iconColor: Colors.orangeAccent,
            ),
            const SizedBox(height: 16),

            // --- SECTION: AI RECOMMENDATION ---
            _buildInfoCard(
              title: "AI Recommendation",
              content: review!["ai_recommendation"] ?? "-",
              icon: Icons.auto_awesome_rounded,
              iconColor: greenColor,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGET UTK KONTEN KARTU ---
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: inputColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: inputColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
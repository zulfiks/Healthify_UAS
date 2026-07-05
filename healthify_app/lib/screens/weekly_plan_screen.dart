import 'package:flutter/material.dart';
import '../models/weekly_plan_model.dart';
import '../services/api_service.dart';

class WeeklyPlanScreen extends StatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  WeeklyPlanModel? plan;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPlan();
  }

  Future<void> loadPlan() async {
    plan = await ApiService().getWeeklyPlan(10);

    setState(() {
      loading = false;
    });
  }

  // Helper Custom Card untuk menampilkan plan
  Widget _buildPlanCard({
    required Color iconBgColor,
    required IconData iconData,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616), // Dark Grey
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Pastikan align di atas agar teks memanjang ke bawah
        children: [
          // Icon Kiri
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Konten Teks Tengah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  // Tidak ada pembatasan maxLines agar teks tidak terpotong
                  style: const TextStyle(
                    color: Colors.white70, // Abu-abu terang
                    fontSize: 14,
                    height: 1.4, // Spasi antar baris
                  ),
                ),
              ],
            ),
          ),
          // Panah (>) Dihapus sesuai permintaan
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFC7F464)),
        ),
      );
    }

    // Jika gagal load / null
    if (plan == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("Gagal memuat rencana.", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black, // Tema Gelap
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI Personal Weight\nLoss Plan",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Rencana mingguan personal yang dibuat khusus untukmu oleh AI",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Pill Tanggal Mingguan
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E3329),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 12, color: Colors.white70),
                                  SizedBox(width: 6),
                                  Text(
                                    "Minggu Ini",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Ilustrasi Kanan Atas (Diganti Icon karena gambar tidak tersedia)
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF114232), // Dark Green
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fact_check,
                          size: 60,
                          color: Color(0xFFC7F464),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- List Card Rencana ---
              _buildPlanCard(
                iconBgColor: const Color(0xFFC7F464), // Lime Green
                iconData: Icons.track_changes,
                iconColor: Colors.black,
                title: "🎯 Fokus Minggu Ini",
                content: plan!.focus,
              ),

              _buildPlanCard(
                iconBgColor: const Color(0xFF80CBC4), // Soft Cyan
                iconData: Icons.directions_walk,
                iconColor: Colors.black,
                title: "🚶 Target Aktivitas",
                content: plan!.activityTarget,
              ),

              _buildPlanCard(
                iconBgColor: const Color(0xFFC7F464), // Lime Green
                iconData: Icons.eco,
                iconColor: Colors.black,
                title: "🌱 Habit Kecil",
                content: plan!.smallHabit,
              ),

              _buildPlanCard(
                iconBgColor: const Color(0xFFFFCC80), // Soft Orange
                iconData: Icons.restaurant,
                iconColor: Colors.black,
                title: "🍽️ Menu Lokal Sehat",
                content: plan!.menuRecommendation,
              ),

              const SizedBox(height: 16),

              // --- Banner Bawah (Konsistensi adalah kunci!) ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF114232), // Dark Green
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC7F464), // Lime Green
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Konsistensi adalah kunci!",
                            style: TextStyle(
                              color: Color(0xFFC7F464), // Lime Green
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Ikuti rencana ini langkah demi langkah untuk hasil terbaik.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // Ruang kosong di bawah
            ],
          ),
        ),
      ),
    );
  }
}
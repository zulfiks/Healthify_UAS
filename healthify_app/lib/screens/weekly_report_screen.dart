import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import '../services/pdf_service.dart';
import '../services/chart_service.dart';
import '../widgets/weight_chart.dart';
import '../widgets/calorie_chart.dart';
import 'package:screenshot/screenshot.dart';
// import '../services/pdf_chart_service.dart';

class WeeklyReportScreen extends StatefulWidget {
  final int userId;

  const WeeklyReportScreen({
    super.key,
    required this.userId,
  });

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  Map<String, dynamic>? user;
  Map<String, dynamic>? report;

  List<dynamic> foodHistory = [];
  List<dynamic> topFoods = [];
  List<dynamic> weightHistory = [];

  Map<String, dynamic>? latestScreening;
  Map<String, dynamic>? coaching;
  final ScreenshotController weightController = ScreenshotController();
  final ScreenshotController caloriesController = ScreenshotController();
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  Future<void> loadReport() async {
    final result = await ApiService.getWeeklyReport(widget.userId);

    if (mounted) {
      setState(() {
        user = result?['user'];
        report = result?['data'];
        foodHistory = result?['food_history'] ?? [];
        topFoods = result?['top_foods'] ?? [];
        weightHistory = result?['weight_history'] ?? [];
        coaching = result?['coaching'];
        latestScreening = result?['latest_screening'];
        isLoading = false;
      });
    }
  }

  // --- HELPER WARNA TEMA GELAP ---
  final Color _bgColor = Colors.black;
  final Color _cardColor = const Color(0xFF161616); // Abu-abu sangat gelap
  final Color _primaryAccent = const Color(0xFFC7F464); // Lime Green
  final Color _darkGreen = const Color(0xFF114232); // Hijau Tua
  final Color _textColor = Colors.white;
  final Color _subTextColor = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: _primaryAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Weekly Health\nReport",
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _textColor, height: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ringkasan kesehatanmu selama seminggu",
                              style: TextStyle(fontSize: 13, color: _subTextColor),
                            ),
                            const SizedBox(height: 16),
                            // Periode Pill
                            if (report != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E3329),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.calendar_month, size: 14, color: Colors.white70),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        "${DateFormat('dd MMM yyyy').format(DateTime.parse(report!['period_start']))} - ${DateFormat('dd MMM yyyy').format(DateTime.parse(report!['period_end']))}",
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Ilustrasi Placeholder
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E3329),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.assignment_turned_in, size: 50, color: Color(0xFF4DB6AC)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- TOMBOL DOWNLOAD PDF ---
                  ElevatedButton(
                    onPressed: () async {
                      PdfService.generateWeeklyReport(
                        user,
                        report,
                        foodHistory,
                        topFoods,
                        weightHistory,
                        coaching,
                        latestScreening,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _darkGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: _primaryAccent, shape: BoxShape.circle),
                          child: const Icon(Icons.download, color: Colors.black, size: 20),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Download Laporan PDF", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("Simpan laporan mingguanmu", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- DATA GRID (6 KOTAK) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          iconLeft: Icons.local_fire_department,
                          iconColor: Colors.orange,
                          title: "Rata-rata Kalori",
                          value: "${report?['avg_calories'] ?? '-'}",
                          subValue: "kcal/hari",
                          iconRight: Icons.water_drop_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          iconLeft: Icons.rice_bowl,
                          iconColor: Colors.orangeAccent,
                          title: "Makanan Paling Sering",
                          value: "${report?['frequent_food'] ?? '-'}",
                          subValue: "",
                          iconRight: Icons.restaurant_menu,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          iconLeft: Icons.scale,
                          iconColor: _primaryAccent,
                          title: "Perubahan Berat",
                          value: "${report?['weight_change'] ?? '-'} kg",
                          subValue: "Dari minggu lalu",
                          iconRight: Icons.monitor_weight_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          iconLeft: Icons.bar_chart,
                          iconColor: Colors.greenAccent,
                          title: "BMI Terakhir",
                          value: "${latestScreening?['imt_value'] ?? '-'} (${latestScreening?['imt_classification'] ?? '-'})",
                          subValue: "Risiko: ${latestScreening?['risk_level'] ?? '-'}",
                          iconRight: Icons.favorite_border,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          iconLeft: Icons.warning_amber_rounded,
                          iconColor: Colors.amber,
                          title: "Health Alert",
                          value: latestScreening?['risk_level'] == 'Very High' 
                              ? 'Kurangi gula & tingkatkan aktivitas fisik.' 
                              : 'Pertahankan pola hidup sehat.',
                          subValue: "",
                          iconRight: Icons.shield_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          iconLeft: Icons.lightbulb,
                          iconColor: _primaryAccent,
                          title: "Rekomendasi",
                          value: "${report?['recommendation'] ?? '-'}",
                          subValue: "",
                          iconRight: Icons.emoji_objects_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- RIWAYAT MAKANAN MINGGU INI (Horizontal) ---
                  const Text("🍽️ Riwayat Makanan Minggu Ini", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildFoodHistoryHorizontal(),
                  const SizedBox(height: 25),

                  // --- TOP MAKANAN & RIWAYAT BERAT BADAN ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTopFoodsList(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildWeightHistoryList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // ===== TREN BERAT BADAN =====
                  Container(
                    height: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "📈 Tren Berat Badan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: WeightChart(
                            spots: ChartService.buildWeightSpots(weightHistory),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== RATA-RATA KALORI =====
                  Container(
                    height: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "🔥 Rata-rata Kalori",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: CalorieChart(
                            bars: ChartService.buildCaloriesBars(foodHistory),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- RINGKASAN MINGGU INI ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF1E3329), borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.assignment, color: Color(0xFFC7F464), size: 20),
                            SizedBox(width: 8),
                            Text("Ringkasan Minggu Ini", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "${report?['report_text'] ?? 'Belum ada ringkasan minggu ini.'}",
                          style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- COACHING JIKA ADA ---
                  _buildCoachingBanner(),
                  const SizedBox(height: 20),

                  // --- TARGET MINGGU DEPAN ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: _darkGreen, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.track_changes, color: Color(0xFFC7F464), size: 20),
                            SizedBox(width: 8),
                            Text("Target Minggu Depan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildTargetItem(Icons.edit_note, "Catat makanan\nminimal 5 hari"),
                            _buildTargetItem(Icons.local_cafe, "Kurangi minuman\nmanis"),
                            _buildTargetItem(Icons.directions_walk, "Jalan kaki 20 menit\nsetiap hari"),
                            _buildTargetItem(Icons.bedtime, "Hindari makan malam\nterlalu larut"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS & HELPERS
  // ==========================================

  Widget _buildInfoCard({
    required IconData iconLeft,
    required Color iconColor,
    required String title,
    required String value,
    required String subValue,
    required IconData iconRight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconLeft, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (subValue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subValue, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(iconRight, color: Colors.white10, size: 30),
          )
        ],
      ),
    );
  }

  Widget _buildFoodHistoryHorizontal() {
    if (foodHistory.isEmpty) {
      return const Text("Belum ada data makanan.", style: TextStyle(color: Colors.grey));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: foodHistory.map((food) {
          final DateTime dateObj = DateTime.parse(food['log_date']);
          final String dayStr = DateFormat('EEE').format(dateObj); // Sen, Sel...
          final String dateStr = DateFormat('dd MMM').format(dateObj); // 26 Mei

          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Text(dayStr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 12),
                Text("${food['total_calories']}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("kcal", style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 12),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFC7F464), shape: BoxShape.circle),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopFoodsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("🥇 Makanan Teratas", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (topFoods.isEmpty) const Text("Data tidak tersedia", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ...topFoods.asMap().entries.map((entry) {
            int index = entry.key;
            var food = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFC7F464), shape: BoxShape.circle),
                    child: Text("${index + 1}", style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("${food['food_name']}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  Text("${food['jumlah']}x", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeightHistoryList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("⚖️ Riwayat Berat", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (weightHistory.isEmpty) const Text("Data tidak tersedia", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ...weightHistory.take(5).map((w) { // Ambil maksimal 5 data agar rapi
            final date = DateFormat('dd MMM').format(DateTime.parse(w['created_at']));
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  Text("${w['weight']} kg", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCoachingBanner() {
    if (coaching == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E3329), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Color(0xFFC7F464), size: 20),
              SizedBox(width: 8),
              Text("Coaching Minggu Ini", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text("${coaching!['template']['title']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text("${coaching!['template']['message']}", style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTargetItem(IconData icon, String text) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 40, // Setengah layar dikurangi padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _primaryAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
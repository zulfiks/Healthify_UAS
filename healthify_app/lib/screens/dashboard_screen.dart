import 'package:flutter/material.dart';
import 'dart:async'; // Tambahan untuk Timer Carousel
import 'dart:math' as math;
import 'food_search_screen.dart';
import 'screening_page.dart';
import 'login_screen.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile_screen.dart';
import 'coaching_screen.dart';
import 'weekly_report_screen.dart';
import 'craving_screen.dart';
import 'weekly_plan_screen.dart';
import 'activity_screen.dart';
import 'education_screen.dart';
import 'weight_loss_plan_screen.dart';
import 'smart_reminder_screen.dart';
import 'medical_safety_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'leaderboard_screen.dart';
import 'activity_recommendation_screen.dart';
import 'expert_review_result_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const DashboardScreen({super.key, this.userData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalKaloriHariIni = 0;
  List<dynamic> _riwayatMakanan = [];
  List<dynamic> _leaderboardData = [];
  bool _isLoading = true;
  Map<String, dynamic>? _latestScreening;
  String _aiSmartMessage = "Menganalisis pola makanmu...";
  String _obesityAlert = "";
  bool get _showReadMore => _coachingMessage.length > 90;
  int _currentStreak = 0;
  int _bestStreak = 0;
  String _weightLossFocus = "";
  String _coachingMessage = "";
  bool _streakActive = false;
  int _pendingReminder = 0;
  Map<String, dynamic>? _expertReview;
  Map<String, dynamic>? _activityRecommendation;

  // Target Nutrisi Default Makro
  final int _targetKalori = 1800;
  final int _proteinTarget = 60;
  final int _fatTarget = 50;
  final int _carbsTarget = 200;

  // Nilai Makro Riil (Hasil kalkulasi dari log makanan hari ini)
  int _proteinHariIni = 0;
  int _fatHariIni = 0;
  int _carbsHariIni = 0;

  // --- CAROUSEL STATE ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  // --- QUICK ACTION SCROLL STATE ---
  final ScrollController _quickActionScrollController = ScrollController();
  int _quickActionDotIndex = 0;

  @override
  void initState() {
    super.initState();
    _startCarousel(); // Mulai timer carousel

    // Listener untuk titik-titik (dots) di Quick Actions
    _quickActionScrollController.addListener(() {
      if (_quickActionScrollController.position.maxScrollExtent > 0) {
        double offset = _quickActionScrollController.offset;
        double max = _quickActionScrollController.position.maxScrollExtent;
        double percentage = (offset / max).clamp(0.0, 1.0);
        int newIndex = (percentage * 2).round(); // Membuat output: 0, 1, atau 2
        
        if (newIndex != _quickActionDotIndex) {
          setState(() {
            _quickActionDotIndex = newIndex;
          });
        }
      }
    });

    if (widget.userData != null) {
      _fetchDashboardData();
      _loadActivityRecommendation();
      _loadReminderCount();
    } else {
      _isLoading = false;
    }
  }

  // --- FUNGSI CAROUSEL OTOMATIS ---
  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        // Hitung total item carousel dinamis
        int itemCount = 1; // Pasti ada motivation
        if (_activityRecommendation != null) itemCount++;
        if (_expertReview != null) itemCount++;

        if (itemCount > 1) {
          _currentPage++;
          if (_currentPage >= itemCount) {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    _quickActionScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadReminderCount() async {
    if (widget.userData == null) return;
    final reminders = await ApiService.getSmartReminders(widget.userData!['id']);
    int pending = reminders.where((e) => !e.isCompleted).length;

    if (!mounted) return;
    setState(() {
      _pendingReminder = pending;
    });
  }

  Future<void> _fetchDashboardData() async {
    if (widget.userData == null) {
      setState(() {
        _isLoading = false;
        _aiSmartMessage = "Selamat Datang! Silakan login untuk fitur lengkap.";
      });
      return;
    }

    setState(() => _isLoading = true);
    final int userId = widget.userData!['id'];
    final streakData = await ApiService.getStreak(userId);

    try {
      final logData = await ApiService.getTodayFoodLogs(userId);
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/food-logs/today/$userId'));
      final fetchedLeaderboard = await ApiService.getLeaderboard("5");
      
      _obesityAlert = await ApiService.getObesityAlert(userId);
      final coaching = await ApiService.getDailyCoaching(userId);
      final expertReview = await ApiService.getUserExpertReview(userId);
      final weightPlan = await ApiService.getWeightLossPlan(userId);

      if (coaching != null) {
        _coachingMessage = coaching['motivation'] ?? "";
      }
      if (weightPlan != null && weightPlan['success'] == true) {
        final String plan = weightPlan['plan'];
        _weightLossFocus = _extractSection(plan, "Focus:");
      }

      Map<String, dynamic>? screeningData;
      String alertMessage = "";
      String reminderMessage = "";

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        alertMessage = data['alert_message'] ?? "";
        reminderMessage = data['reminder_message'] ?? "";
        screeningData = data['latest_screening'];
      }

      if (mounted) {
        setState(() {
          if (logData != null && logData['success'] == true) {
            _totalKaloriHariIni = int.tryParse(logData['total_kalori'].toString()) ?? 0;
            _proteinHariIni = int.tryParse(logData['total_protein'].toString()) ?? 0;
            _carbsHariIni = int.tryParse(logData['total_carbs'].toString()) ?? 0;
            _fatHariIni = int.tryParse(logData['total_fat'].toString()) ?? 0;
            _riwayatMakanan = logData['logs'] ?? [];
          }
          _currentStreak = streakData['current_streak'] ?? 0;
          _bestStreak = streakData['best_streak'] ?? 0;
          _streakActive = streakData['is_active'] ?? false;
          _latestScreening = screeningData;
          _leaderboardData = fetchedLeaderboard;
          _expertReview = expertReview;

          if (alertMessage.isNotEmpty) {
            _aiSmartMessage = alertMessage;
          } else if (_totalKaloriHariIni > _targetKalori) {
            _aiSmartMessage = "Asupan kalori hari ini sudah melampaui batas target harianmu.";
          } else if (_latestScreening != null && _latestScreening!['imt_classification'] != null) {
            _aiSmartMessage = "Status IMT terakhirmu: ${_latestScreening!['imt_classification']}. Jaga pola makan ya!";
          } else {
            _aiSmartMessage = reminderMessage.isNotEmpty ? reminderMessage : "Pola makanmu sudah cukup baik hari ini.";
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiSmartMessage = "Gagal memuat analisis data dari server.";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadActivityRecommendation() async {
    if (widget.userData == null) return;
    final int userId = widget.userData!['id'];
    final result = await ApiService.getActivityRecommendation(userId);

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _activityRecommendation = result;
      });
    }
  }

  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/6285748898905?text=Halo%20Healthify");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _handleProtectedNavigation(Widget targetScreen) {
    if (widget.userData == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)).then((_) async {
        await _fetchDashboardData();
        await _loadReminderCount();
      });
    }
  }

  // Helper Tema Gelap
  final Color _bgColor = Colors.black;
  final Color _cardColor = const Color(0xFF161616);
  final Color _darkGreen = const Color(0xFF114232);
  final Color _limeGreen = const Color(0xFFC7F464);

  @override
  Widget build(BuildContext context) {
    String userName = widget.userData?['name'] ?? 'Tamu';
    String statusRisiko = _latestScreening?['risk_level'] ?? widget.userData?['klasifikasi_risiko'] ?? 'Normal';
    String? profilePicture = widget.userData?['profile_picture'];

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: _limeGreen))
            : RefreshIndicator(
                onRefresh: () async {
                  await _fetchDashboardData();
                  await _loadReminderCount();
                },
                color: _limeGreen,
                backgroundColor: _cardColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER & PROFILE ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => ProfileScreen(userData: widget.userData)),
                                    ).then((_) => _fetchDashboardData());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: _limeGreen, width: 2),
                                    ),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: _darkGreen,
                                      child: ClipOval(
                                        child: (profilePicture != null && profilePicture.isNotEmpty)
                                            ? Image.network(
                                                "$profilePicture?${DateTime.now().millisecondsSinceEpoch}",
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Text(
                                                    userName[0].toUpperCase(),
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                                  );
                                                },
                                              )
                                            : Text(
                                                userName[0].toUpperCase(),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Welcome to Healthify', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      Text(
                                        userName,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildNotificationButton(),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _streakActive ? Colors.orange.withValues(alpha: 0.15) : Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: _streakActive ? Colors.orangeAccent : Colors.grey,
                                  size: 24,
                                ),
                                const SizedBox(height: 2),
                                Column(
                                  children: [
                                    Text(
                                      "$_currentStreak",
                                      style: TextStyle(
                                        color: _currentStreak > 0 ? Colors.orangeAccent : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      "Best $_bestStreak",
                                      style: const TextStyle(color: Colors.white54, fontSize: 8),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // 1. HEALTH ALERT
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF422B0A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Health Alert", style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _obesityAlert.isNotEmpty ? _obesityAlert : _aiSmartMessage,
                                    style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 2. HEALTH STATUS CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: _darkGreen, borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.health_and_safety, color: Color(0xFFC7F464), size: 20),
                                SizedBox(width: 8),
                                Text("Health Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 2, child: _buildStatusColumn("BMI", _latestScreening?['imt_value']?.toString() ?? '-')),
                                const SizedBox(width: 4),
                                Expanded(flex: 3, child: _buildStatusColumn("Status", _latestScreening?['imt_classification'] ?? '-', color: Colors.orangeAccent)),
                                const SizedBox(width: 4),
                                Expanded(flex: 3, child: _buildStatusColumn("Risk Level", statusRisiko, color: Colors.redAccent)),
                                const SizedBox(width: 4),
                                Expanded(flex: 3, child: _buildStatusColumn("Goal", "Weight Loss", color: _limeGreen)),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomPaint(
                                        size: const Size(100, 100),
                                        painter: CircleProgressPainter(progress: (_totalKaloriHariIni / _targetKalori).clamp(0.0, 1.0)),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('$_totalKaloriHariIni', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                          const Text('kcal', style: TextStyle(fontSize: 10, color: Colors.white54)),
                                          Text('Target $_targetKalori', style: const TextStyle(fontSize: 9, color: Colors.white54)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.track_changes, color: Color(0xFFC7F464), size: 16),
                                          SizedBox(width: 6),
                                          Expanded(child: Text("AI Personal Weight Loss Plan", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Focus this week", style: TextStyle(color: Color(0xFFC7F464), fontSize: 11, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              _weightLossFocus.isNotEmpty ? _weightLossFocus : "AI sedang membuat fokus minggu ini.",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: Colors.white, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () => _handleProtectedNavigation(
                                          WeightLossPlanScreen(userId: widget.userData?['id'] ?? 0),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(color: _limeGreen, borderRadius: BorderRadius.circular(20)),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("See Full Plan", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                                              SizedBox(width: 4),
                                              Icon(Icons.arrow_forward, color: Colors.black, size: 14),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 3. TODAY'S SUMMARY
                      const Text("📊 Today's Summary", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard(Icons.local_fire_department, "Calories", "$_totalKaloriHariIni", "kcal", _limeGreen),
                          _buildSummaryCard(Icons.restaurant, "Protein", "$_proteinHariIni", "g", Colors.orangeAccent),
                          _buildSummaryCard(Icons.opacity, "Fat", "$_fatHariIni", "g", Colors.redAccent),
                          _buildSummaryCard(Icons.grain, "Carbs", "$_carbsHariIni", "g", Colors.greenAccent),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // 4. LAST FOOD + CEK REPORT + CRAVING EMERGENCY
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kiri: Last Food
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.restaurant, color: Colors.white, size: 16),
                                      SizedBox(width: 8),
                                      Text("Last Food", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (_riwayatMakanan.isNotEmpty)
                                    Column(
                                      children: _riwayatMakanan.take(1).map((food) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: const CircleAvatar(backgroundColor: Colors.white10, child: Icon(Icons.fastfood, color: Colors.grey)),
                                          title: Text(
                                            food['food_name'],
                                            style: const TextStyle(color: Colors.white, fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${food['total_calories']} kcal"),
                                              Text("P ${food['protein']}g • C ${food['carbs']}g • F ${food['fat']}g", style: const TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  else
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 25),
                                      child: Center(child: Text("Belum ada data makanan", style: TextStyle(color: Colors.grey, fontSize: 12))),
                                    ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _handleProtectedNavigation(FoodSearchScreen(userId: widget.userData?['id'] ?? 0)),
                                      icon: const Icon(Icons.add),
                                      label: const Text("Tambah", style: TextStyle(fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFC7F464),
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Kanan: Cek Report & Tombol Craving Card
                          Expanded(
                            child: Column(
                              children: [
                                // Cek Report Card
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.calendar_month, color: Colors.white, size: 16),
                                          SizedBox(width: 8),
                                          Text("Cek Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 45,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _handleProtectedNavigation(WeeklyReportScreen(userId: widget.userData?['id'] ?? 0)),
                                          icon: const Icon(Icons.analytics_outlined),
                                          label: const Text("Weekly Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF263A69),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Craving Emergency Card Form
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.bolt, color: Colors.redAccent, size: 16),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text("Craving Emergency", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 45,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.flash_on, size: 18),
                                          label: const Text("Laper?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => CravingScreen(userId: widget.userData?['id'] ?? 0)));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // 5. LEADERBOARD (DIPINDAHKAN KE SINI)
                      _buildLeaderboardCard(userName),
                      const SizedBox(height: 25),
                      
                      // 6. CAROUSEL (DENGAN JUDUL BARU "DAILY HIGHLIGHTS")
                      _buildForYouCarousel(),
                      const SizedBox(height: 25),

                      // 7. QUICK ACTIONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.bolt, color: Colors.yellowAccent, size: 20),
                              SizedBox(width: 8),
                              Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Geser", style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(width: 2),
                              const Icon(Icons.chevron_right, color: Colors.white54, size: 16),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        controller: _quickActionScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildQuickActionButton(
                              title: "AI Loss Plan",
                              icon: Icons.auto_awesome,
                              bgColor: const Color(0xFF4DB6AC),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(WeightLossPlanScreen(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Chat AI\nHealthify",
                              icon: Icons.smart_toy,
                              bgColor: const Color(0xFF263A69),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: openWhatsApp,
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Activity",
                              icon: Icons.directions_run,
                              bgColor: const Color(0xFF1B2D4B),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(ActivityScreen(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Food Log",
                              icon: Icons.add,
                              bgColor: _limeGreen,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              onTap: () => _handleProtectedNavigation(FoodSearchScreen(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Weekly Report",
                              icon: Icons.bar_chart,
                              bgColor: _darkGreen,
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(WeeklyReportScreen(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Medical\nSafety",
                              icon: Icons.health_and_safety,
                              bgColor: const Color(0xFF8B1E3F),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(MedicalSafetyScreen(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Education",
                              icon: Icons.menu_book_rounded,
                              bgColor: const Color.fromARGB(255, 205, 147, 80),
                              iconColor: const Color.fromARGB(255, 255, 255, 255),
                              textColor: const Color.fromARGB(255, 255, 255, 255),
                              onTap: () => _handleProtectedNavigation(const EducationScreen()),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "AI Plan",
                              icon: Icons.track_changes,
                              bgColor: const Color.fromARGB(255, 208, 143, 62),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(WeightLossPlanScreen(userId: widget.userData!['id'])),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Screening",
                              icon: Icons.health_and_safety,
                              bgColor: Colors.orangeAccent,
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(ScreeningPage(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickActionButton(
                              title: "Coaching",
                              icon: Icons.psychology,
                              bgColor: Colors.purpleAccent,
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              onTap: () => _handleProtectedNavigation(CoachingScreen(userId: widget.userData?['id'] ?? 0)),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // TITIK TITIK QUICK ACTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _quickActionDotIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _quickActionDotIndex == index ? _limeGreen : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // =====================================
  // WIDGET HELPERS (NEW & OLD)
  // =====================================

  // WIDGET CAROUSEL BARU MENGGABUNGKAN EXPERT REVIEW, MOTIVASI, DAN AKTIVITAS
  Widget _buildForYouCarousel() {
    List<Widget> carouselItems = [];

    // 1. Tambahkan Expert Review (Jika ada)
    if (_expertReview != null) {
      carouselItems.add(
        _buildPromoCard(
          title: "Expert Review", 
          description: "Status: ${_expertReview!['status']}\nExpert: ${_expertReview!['expert_name']}",
          leftIcon: Icons.medical_services_rounded,
          leftColor: Colors.greenAccent,
          buttonText: "Lihat Review",
          buttonIcon: Icons.assignment_turned_in_rounded,
          onTapButton: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => ExpertReviewResultScreen(userId: widget.userData!['id']))
            );
          },
        ),
      );
    }

    // 2. Tambahkan Motivation
    carouselItems.add(
      _buildPromoCard(
        title: "Today's Motivation",
        description: _coachingMessage.isNotEmpty ? _coachingMessage : "Pertahankan kebiasaan baikmu hari ini!",
        leftIcon: Icons.psychology_rounded,
        leftColor: _limeGreen,
        buttonText: "Read More",
        buttonIcon: Icons.chat_bubble_outline_rounded,
        onTapButton: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CoachingScreen(userId: widget.userData!['id']),
            ),
          );
        },
      ),
    );

    // 3. Tambahkan Aktivitas (Jika ada)
    if (_activityRecommendation != null) {
      carouselItems.add(
        _buildPromoCard(
          title: "Aktivitas Hari Ini", 
          description: "${_activityRecommendation!['duration_minutes']} Menit\n${_activityRecommendation!['activity_name']}",
          leftIcon: Icons.directions_run_rounded,
          leftColor: Colors.blueAccent,
          buttonText: "Lihat Detail",
buttonIcon: Icons.arrow_forward_rounded,
onTapButton: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ActivityRecommendationScreen(
        userId: widget.userData!['id'],
      ),
    ),
  );
}, // Disable
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "✨ Daily Highlights", // Judul diganti menjadi Daily Highlights
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text("View All", style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 155, // Tinggi card seragam
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: carouselItems,
          ),
        ),
        const SizedBox(height: 12),
        // Indikator Titik (Dots) di bawah carousel
        if (carouselItems.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              carouselItems.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? _limeGreen : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // WIDGET CARD KONTEN CAROUSEL 
  Widget _buildPromoCard({
    required String title,
    required String description,
    required IconData leftIcon,
    required Color leftColor,
    required String buttonText,
    required IconData buttonIcon,
    VoidCallback? onTapButton,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              color: leftColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Icon(leftIcon, size: 48, color: leftColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: leftColor, // Judul dibuat berwarna
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Dibuat bisa dua baris
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 3, // Dibuat bisa meluas hingga tiga baris
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: onTapButton,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: onTapButton != null ? _limeGreen : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(buttonIcon, size: 14, color: onTapButton != null ? Colors.black : Colors.white54),
                          const SizedBox(width: 6),
                          Text(
                            buttonText,
                            style: TextStyle(
                              color: onTapButton != null ? Colors.black : Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _extractSection(String text, String keyword) {
    if (!text.contains(keyword)) return "-";
    int start = text.indexOf(keyword) + keyword.length;
    int end = text.length;
    List<String> keywords = ["Focus:", "Activity Target:", "Small Habit:", "Menu Recommendation:"];
    for (String k in keywords) {
      if (k == keyword) continue;
      int idx = text.indexOf(k, start);
      if (idx != -1 && idx < end) {
        end = idx;
      }
    }
    return text.substring(start, end).trim();
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SmartReminderScreen(userId: widget.userData!['id'])),
        );
        _loadReminderCount();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
          ),
          if (_pendingReminder > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  "$_pendingReminder",
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(String title, String value, {Color color = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value, String unit, Color iconColor) {
    return Container(
      width: (MediaQuery.of(context).size.width - 40 - 36) / 4,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard(String userName) {
    final List<dynamic> sortedUsers = List.from(_leaderboardData);
    sortedUsers.sort((a, b) => (int.tryParse(b['skor']?.toString() ?? '0') ?? 0)
        .compareTo(int.tryParse(a['skor']?.toString() ?? '0') ?? 0));

    Map<String, dynamic> p1 = sortedUsers.isNotEmpty ? sortedUsers[0] : {'name': 'User 1', 'skor': 0};
    Map<String, dynamic> p2 = sortedUsers.length > 1 ? sortedUsers[1] : {'name': 'User 2', 'skor': 0};
    Map<String, dynamic> p3 = sortedUsers.length > 2 ? sortedUsers[2] : {'name': 'User 3', 'skor': 0};
    Map<String, dynamic> p4 = sortedUsers.length > 3 ? sortedUsers[3] : {'name': 'User 4', 'skor': 0};
    Map<String, dynamic> p5 = sortedUsers.length > 4 ? sortedUsers[4] : {'name': 'User 5', 'skor': 0};

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.leaderboard, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text('Top 5 Minggu Ini', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Text('Lihat Semua', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 11),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPodiumItem(user: p5, rank: '5', podiumHeight: 40, podiumColor: Colors.white24, textColor: Colors.white, hasGlow: false),
              _buildPodiumItem(user: p3, rank: '3', podiumHeight: 65, podiumColor: Colors.white38, textColor: Colors.white, hasGlow: false),
              _buildPodiumItem(user: p1, rank: '1', podiumHeight: 100, podiumColor: const Color(0xFFFBBF24), textColor: Colors.black, hasGlow: true),
              _buildPodiumItem(user: p2, rank: '2', podiumHeight: 80, podiumColor: Colors.white38, textColor: Colors.white, hasGlow: false),
              _buildPodiumItem(user: p4, rank: '4', podiumHeight: 50, podiumColor: Colors.white24, textColor: Colors.white, hasGlow: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem({
    required Map<String, dynamic> user,
    required String rank,
    required double podiumHeight,
    required Color podiumColor,
    required Color textColor,
    required bool hasGlow,
  }) {
    String name = user['name'] ?? '-';
    String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: rank == '1' ? const Color(0xFFFBBF24) : Colors.white10, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(rank, style: TextStyle(color: rank == '1' ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
        ),
        const SizedBox(height: 6),
        Container(
          width: rank == '1' ? 46 : 38,
          height: rank == '1' ? 46 : 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: rank == '1' ? const Color(0xFFFFF176) : Colors.white24, width: rank == '1' ? 2.5 : 1.5),
            boxShadow: hasGlow ? [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 1)] : null,
          ),
          child: CircleAvatar(
            backgroundColor: rank == '1' ? const Color(0xFFD97706) : Colors.white10,
            child: Text(initial, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: rank == '1' ? 14 : 12)),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 48,
          child: Text(
            name.toLowerCase(),
            style: TextStyle(color: Colors.white, fontSize: rank == '1' ? 11 : 10, fontWeight: rank == '1' ? FontWeight.bold : FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 48,
          height: podiumHeight,
          decoration: BoxDecoration(color: podiumColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('${user['skor'] ?? 0}', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: rank == '1' ? 13 : 11)),
              if (rank == '1') ...[
                const SizedBox(height: 2),
                const Icon(Icons.star_rounded, color: Colors.black, size: 12),
              ]
            ],
          ),
        ),
      ],
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final Paint trackPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = const Color(0xFFC7F464)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi * 0.75, math.pi * 1.5, false, trackPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi * 0.75, (math.pi * 1.5) * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
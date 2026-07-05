import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../expert_review_screen.dart';
import '../login_screen.dart';

class ExpertDashboardScreen extends StatefulWidget {
  const ExpertDashboardScreen({super.key});

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  List users = [];
  List filteredUsers = [];
  int totalUsers = 0;
  int reviewedUsers = 0;
  int pendingUsers = 0;
  bool loading = true;
  
  // --- FILTER & SEARCH STATE ---
  String selectedFilter = "All"; // Opsi: All, Approved, Revised, Pending, Unreviewed
  String searchQuery = "";

  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color greenColor = const Color(0xFFC7F464);

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final data = await ApiService.getExpertUsers();

      if (!mounted) return;

      setState(() {
        users = data;
        totalUsers = data.length;

        reviewedUsers = data.where((u) {
          return u["review_status"] == "approved" ||
                 u["review_status"] == "revised";
        }).length;

        pendingUsers = totalUsers - reviewedUsers;
        loading = false;
        
        // Aplikasikan filter saat data baru dimuat
        _applyFilters();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memuat data pengguna"),
        ),
      );
    }
  }

  // --- LOGIKA FILTER & PENCARIAN ---
  void _applyFilters() {
    setState(() {
      filteredUsers = users.where((u) {
        // 1. Cek Pencarian (Search Query)
        final matchesSearch = u["name"]
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        // 2. Cek Filter Status
        final status = u["review_status"]?.toString().toLowerCase() ?? "";
        bool matchesFilter = false;

        if (selectedFilter == "All") {
          matchesFilter = true;
        } else if (selectedFilter == "Approved" && status == "approved") {
          matchesFilter = true;
        } else if (selectedFilter == "Revised" && status == "revised") {
          matchesFilter = true;
        } else if (selectedFilter == "Pending" && status == "pending") {
          matchesFilter = true;
        } else if (selectedFilter == "Unreviewed" && (status.isEmpty || status == "null")) {
          matchesFilter = true;
        }

        // Tampilkan jika sesuai dengan kata kunci DAN status filter
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void searchUser(String keyword) {
    searchQuery = keyword;
    _applyFilters();
  }

  // --- HELPER UNTUK TANGGAL HARI INI ---
  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return "${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
  }

  // --- WIDGET HEADER CUSTOM KEKINIAN ---
  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Menuju Halaman Profile..."),
                      backgroundColor: Colors.black87,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: greenColor,
                      child: const Icon(
                        Icons.face_retouching_natural_rounded, 
                        color: Colors.black, 
                        size: 26
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Good Morning",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Dr. Expert", 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // DATE CHIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getFormattedDate(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // BIG TITLE
          const Text(
            "Today,\nReviews+",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET FILTER CHIPS ---
  Widget _buildFilterChips() {
    final filters = ["All", "Approved", "Revised", "Pending", "Unreviewed"];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                selectedFilter = filter;
                _applyFilters();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? greenColor : cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? greenColor : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER BAGIAN ATAS
            _buildCustomHeader(),
            
            // KONTEN UTAMA
            Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(color: greenColor),
                    )
                  : Column(
                      children: [
                        // STATS CARDS SECTION
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  "Total User",
                                  totalUsers.toString(),
                                  Icons.people_alt_rounded,
                                  Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  "Reviewed",
                                  reviewedUsers.toString(),
                                  Icons.check_circle_rounded,
                                  greenColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  "Pending",
                                  pendingUsers.toString(),
                                  Icons.schedule_rounded,
                                  Colors.orangeAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SEARCH BAR SECTION
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                          child: TextField(
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            onChanged: searchUser,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: cardColor,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18),
                              hintStyle: const TextStyle(
                                color: Colors.white38,
                                fontSize: 15,
                              ),
                              hintText: "Cari pengguna...",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: greenColor,
                                  size: 26,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        // FILTER CHIPS SECTION
                        _buildFilterChips(),
                        const SizedBox(height: 15),

                        // LIST VIEW SECTION
                        Expanded(
                          child: RefreshIndicator(
                            color: greenColor,
                            backgroundColor: cardColor,
                            onRefresh: loadUsers,
                            child: filteredUsers.isEmpty 
                              ? _buildEmptyState()
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  itemCount: filteredUsers.length,
                                  itemBuilder: (context, index) {
                                    final user = filteredUsers[index];

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // HEADER: AVATAR & NAME
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: greenColor, width: 2),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 28,
                                                    backgroundColor: Colors.grey.shade900,
                                                    backgroundImage: user["profile_picture"] != null &&
                                                            user["profile_picture"].toString().isNotEmpty
                                                        ? NetworkImage(user["profile_picture"])
                                                        : null,
                                                    child: user["profile_picture"] == null ||
                                                            user["profile_picture"].toString().isEmpty
                                                        ? const Icon(
                                                            Icons.person_rounded,
                                                            color: Colors.white54,
                                                            size: 30,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        user["name"]?.toString() ?? "-",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w800,
                                                          letterSpacing: 0.3,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        user["email"]?.toString() ?? "-",
                                                        style: const TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 24),

                                            // CHIPS SECTION
                                            Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: [
                                                _buildCustomChip(
                                                  "BMI ${user['bmi']?.toString() ?? '-'}",
                                                  greenColor,
                                                  Icons.monitor_weight_outlined,
                                                ),
                                                _buildCustomChip(
                                                  user["risk_level"]?.toString() ?? "Belum Screening",
                                                  Colors.white,
                                                  Icons.warning_amber_rounded,
                                                ),
                                                _buildCustomChip(
                                                  user["goal"]?.toString() ?? "-",
                                                  Colors.white,
                                                  Icons.flag_outlined,
                                                ),
                                                _buildCustomChip(
                                                  "${user['food_logs']} Food Logs",
                                                  Colors.white,
                                                  Icons.restaurant_menu_rounded,
                                                ),
                                                _buildCustomChip(
                                                  _statusLabel(user["review_status"]?.toString()),
                                                  _statusColor(user["review_status"]?.toString() ?? ""),
                                                  Icons.assignment_turned_in_rounded,
                                                  isStatus: true,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 24),

                                            // REVIEW BUTTON
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: greenColor,
                                                  foregroundColor: Colors.black,
                                                  elevation: 0,
                                                  minimumSize: const Size.fromHeight(56),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => ExpertReviewScreen(
                                                        userId: user['id'],
                                                      ),
                                                    ),
                                                  );
                                                  loadUsers();
                                                },
                                                child: const Text(
                                                  "Review User",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ), // <--- PENUTUP REFRESH INDICATOR YANG KEMARIN TERLEWAT
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER: EMPTY STATE JIKA FILTER KOSONG
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 60, color: Colors.white24),
              const SizedBox(height: 16),
              const Text(
                "Tidak ada data",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Coba ubah kata kunci atau ganti filter",
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HELPER: MODERN STAT CARD
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // HELPER: MODERN PILL CHIP
  Widget _buildCustomChip(String label, Color color, IconData icon, {bool isStatus = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isStatus ? color.withOpacity(0.15) : cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isStatus ? Colors.transparent : color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.greenAccent;
      case "revised":
        return Colors.orangeAccent;
      case "pending":
        return Colors.lightBlueAccent;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String? status) {
    if (status == null || status.isEmpty) {
      return "Belum Direview";
    }
    return "${status.substring(0, 1).toUpperCase()}${status.substring(1).toLowerCase()}";
  }
}
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'food_search_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MainNavigationScreen({super.key, required this.userData});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 2; // Default aktif di Home (Index 2)

  // Warna Palette
  final Color darkBg = const Color(0xFF181A1F);
  final Color limeGreen = const Color(0xFFD2F564);

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    // Mengambil userId dari userData (sesuaikan key 'id' dengan respons API Anda)
    int userId = widget.userData['id'] ?? 1;

    // Inisialisasi daftar halaman persis sesuai urutan baru
    _screens = [
      // Index 0: Screening (Placeholder sementara)
      const Scaffold(body: Center(child: Text('Screening Page', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))), 
      
      // Index 1: Food
      FoodSearchScreen(userId: userId),           
      
      // Index 2: Home (Dashboard)
      DashboardScreen(userData: widget.userData), 
      
      // Index 3: Report (Placeholder sementara)
      const Scaffold(body: Center(child: Text('Report Page', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))), 
      
      // Index 4: Profile
      const ProfileScreen(),                      
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody = true agar efek melayang (floating navbar) tidak terpotong
      extendBody: true, 
      
      // IndexedStack menjaga agar halaman tidak ngulang loading saat ganti tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // Custom Floating Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: darkBg,
            borderRadius: BorderRadius.circular(40), // Bentuk Pill membulat penuh
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.fact_check_outlined,
                activeIcon: Icons.fact_check,
                label: 'Screening',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.restaurant_menu,
                activeIcon: Icons.restaurant_menu,
                label: 'Food',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: 'Report',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget navigasi yang sudah dioptimalkan ukurannya agar tidak Overflow/Bug Gepeng
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        // Padding diperkecil sedikit agar muat 5 item dengan sempurna
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          color: isActive ? limeGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isActive
            // Tampilan saat Tab Aktif
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(activeIcon, color: darkBg, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: darkBg,
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Font dikecilkan agar aman dari overflow
                    ),
                  ),
                ],
              )
            // Tampilan saat Tab Tidak Aktif
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white54, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10, // Font lebih kecil
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
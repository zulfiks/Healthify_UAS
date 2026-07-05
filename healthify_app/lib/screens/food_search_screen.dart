import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'food_history_screen.dart';
import 'food_ai_screen.dart'; // Pastikan file ini sudah Anda buat

class FoodSearchScreen extends StatefulWidget {
  final int userId;

  const FoodSearchScreen({super.key, required this.userId});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  List<dynamic> _databaseFoods = [];
  List<dynamic> _filteredFoods = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFoodsFromDatabase();
  }

  // ==================== LOGIKA API TIDAK DIUBAH ====================
  Future<void> _fetchFoodsFromDatabase() async {
    final foods = await ApiService.getFoods();
    if (mounted) {
      setState(() {
        _databaseFoods = foods;
        _filteredFoods = foods;
        _isLoading = false;
      });
    }
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredFoods = _databaseFoods.where((food) {
        String nama = food['name']?.toString().toLowerCase() ?? '';
        return nama.contains(query.toLowerCase());
      }).toList();
    });
  }
  // =================================================================

  // Warna Palette Baru
  final Color darkBg = const Color(0xFF181A1F);
  final Color darkGreen = const Color(0xFF054A3B);
  final Color limeGreen = const Color(0xFFD2F564);
  final Color lightBlue = const Color(0xFF4AC2C5);
  final Color peach = const Color(0xFFF7B19C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- BACKGROUND DIUBAH MENJADI HITAM ---
      backgroundColor: Colors.black, 
      body: Stack(
        children: [
          // ======== KREASI BACKGROUND BERDASARKAN PALETTE ========
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: peach.withValues(alpha: 0.15), // Disesuaikan agar halus di hitam
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: lightBlue.withValues(alpha: 0.1), // Disesuaikan agar halus di hitam
                shape: BoxShape.circle,
              ),
            ),
          ),
          // =======================================================

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Kembali & Judul)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF161616), // Dark mode button
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      // TOMBOL KANAN ATAS LOGO HISTORY DAN NAVIGASI
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodHistoryScreen(
  userId: widget.userId,
),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF161616), // Dark mode button
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.history, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Cari Makanan',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Disesuaikan untuk background hitam
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Catat asupan nutrisimu hari ini ✨',
                    style: TextStyle(fontSize: 14, color: Colors.white70), // Disesuaikan untuk background hitam
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161616), // Dark mode search bar
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterSearch,
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari makanan...',
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16, right: 12),
                          child: Icon(Icons.search, color: Colors.white54, size: 26),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24),
  child: Card(
    color: const Color(0xFF161616),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
onTap: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FoodAIScreen(
        userId: widget.userId,
      ),
    ),
  );

  if (result == true) {
    _fetchFoodsFromDatabase();
  }
},
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: limeGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.black,
              ),
            ),

            const SizedBox(width: 16),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    "AI Food Analysis",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Analisis makanan menggunakan AI dan dapatkan rekomendasi meal swap.",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),

          ],
        ),
      ),
    ),
  ),
),
                // Judul List Makanan Populer
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Makanan Populer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Disesuaikan untuk background hitam
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Food List dengan Animasi Slide-In
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: limeGreen))
                      : ListView.builder(
                          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120), 
                          itemCount: _filteredFoods.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _filteredFoods.length) {
                              return _buildTipsCard();
                            }

                            final food = _filteredFoods[index];
                            
                            // Animasi List
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: Duration(milliseconds: 400 + (index * 100)),
                              curve: Curves.easeOutCubic,
                              builder: (context, double value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 50 * (1 - value)),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildFoodCard(food),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    String nama = food['name']?.toString() ?? 'Makanan';
    String kkal = food['calories']?.toString() ?? '0';
    String porsi = food['serving_size']?.toString() ?? '1 Porsi';

    // Placeholder untuk UI
  String protein =
    food['protein']?.toString() ?? '0';

String karbo =
    food['carbs']?.toString() ?? '0';

String lemak =
    food['fat']?.toString() ?? '0';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616), // Dark mode card
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white10, // Border disesuaikan agar nyambung dengan background
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gambar / Icon Makanan
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3329), // Soft dark green
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.fastfood_rounded, color: limeGreen, size: 32),
          ),
          const SizedBox(width: 16),
          
          // Informasi Makanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 16, color: limeGreen),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white), // Teks putih agar jelas
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(porsi, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 12),
                
                // Nutrisi
                Wrap(
  spacing: 12,
  runSpacing: 8,
  children: [
    _buildNutritionChip(
      Icons.local_fire_department,
      "$kkal kkal",
    ),
    _buildNutritionChip(
      Icons.fitness_center,
      "$protein g Protein",
    ),
    _buildNutritionChip(
      Icons.rice_bowl,
      "$karbo g Karbo",
    ),
    _buildNutritionChip(
      Icons.water_drop,
      "$lemak g Lemak",
    ),
  ],
),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Tombol Add
          InkWell(
            onTap: () => _showPortionCalculator(food),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: limeGreen, // Disesuaikan dengan aksen warna
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 20),
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildNutrientStat(String value, String label, {String unit = ''}) {
    return Column(
      children: [
        Text(
          '$value$unit',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white), // Teks diubah putih
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10), // Teks diubah terang
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 20,
      width: 1,
      color: Colors.white24, // Garis diubah lebih redup
    );
  }
  Widget _buildNutritionChip(
  IconData icon,
  String text,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 6,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: limeGreen,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTipsCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3329), // Background disesuaikan ke dark green
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: darkGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips Sehat',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: limeGreen, fontSize: 15)), // Diubah ke limeGreen
                const SizedBox(height: 4),
                const Text(
                  'Pilih makanan tinggi protein dan serat untuk energi yang lebih tahan lama.',
                  style: TextStyle(fontSize: 12, color: Colors.white70), // Teks diubah terang
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPortionCalculator(Map<String, dynamic> food) {
    double selectedPortion = 1.0;
    String namaMakanan = food['name']?.toString() ?? 'Makanan Tidak Diketahui';
    int kaloriStandar = int.tryParse(food['calories']?.toString() ?? '0') ?? 0;
    String satuanStandar = food['serving_size']?.toString() ?? 'Porsi';

final rootContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          int totalCalories = (kaloriStandar * selectedPortion).round();

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF161616), // Dark mode bottom sheet
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.white24, // Garis drag diubah terang
                            borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 24),
                Text(namaMakanan,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)), // Teks putih
                Text('Standar: $kaloriStandar kkal / $satuanStandar',
                    style: const TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 24),
                const Text('Berapa banyak yang kamu makan?',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _portionIconButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (selectedPortion > 0.5) {
                            setModalState(() => selectedPortion -= 0.5);
                          }
                        }),
                    Column(
                      children: [
                        Text('${selectedPortion}x',
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white)),
                        const Text('Porsi',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                    _portionIconButton(
                        icon: Icons.add,
                        onTap: () {
                          if (selectedPortion < 5.0) {
                            setModalState(() => selectedPortion += 0.5);
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPresetChip('½ Porsi', 0.5, selectedPortion,
                        (val) => setModalState(() => selectedPortion = val)),
                    _buildPresetChip('1 Porsi', 1.0, selectedPortion,
                        (val) => setModalState(() => selectedPortion = val)),
                    _buildPresetChip('2 Porsi', 2.0, selectedPortion,
                        (val) => setModalState(() => selectedPortion = val)),
                  ],
                ),
                const SizedBox(height: 32),
                
                // KOTAK TOTAL KALORI
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.black, // Hitam pekat agar kontras di bottom sheet
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Kalori',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      Text('$totalCalories kkal',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: limeGreen)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // ===== LOGIKA SIMPAN API TETAP 100% SAMA =====
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {

  final parentContext = rootContext;

  showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (c) => Center(
      child: CircularProgressIndicator(color: limeGreen),
    ),
  );

                      bool isSuccess = await ApiService.saveFoodLog(
                          widget.userId,
                          food['id'],
                          selectedPortion,
                          totalCalories);

                      if (!context.mounted) return;
                      
                      Navigator.pop(parentContext);
                      Navigator.pop(context);

                     if (isSuccess) {

  

  final mealSwap =
await ApiService.getMealSwap(
widget.userId,
namaMakanan,
);
debugPrint("Makanan = $namaMakanan");
debugPrint(mealSwap.toString());
  if (mealSwap != null &&
      mealSwap['success'] == true) {



    String rekomendasi =
        mealSwap['data']['swap_recommendation'];

    showDialog(
  context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161616),

          title: Text(
            "🍽 Meal Swap",
            style: TextStyle(
              color: limeGreen,
            ),
          ),

          content: Text(
            rekomendasi,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          actions: [

            TextButton(
onPressed: () {
  Navigator.pop(dialogContext);
},

              child: Text(
                "Mengerti",
                style: TextStyle(
                  color: limeGreen,
                ),
              ),
            )

          ],
        );
      },
    );
  }

  ScaffoldMessenger.of(parentContext).showSnackBar(
    SnackBar(
      content: Text(
        'Berhasil mencatat $namaMakanan! ✨',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: limeGreen,
      duration: const Duration(seconds: 2),
    ),
  );
} else {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal menyimpan ke jurnal. Coba lagi! ❌'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: limeGreen,
                      foregroundColor: darkBg,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Simpan ke Jurnal',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _portionIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: limeGreen.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: limeGreen)),
        child: Icon(icon, color: limeGreen, size: 28),
      ),
    );
  }

  Widget _buildPresetChip(String label, double value, double currentValue,
      Function(double) onSelected) {
    bool isSelected = currentValue == value;
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.white70)), // Disesuaikan
      selected: isSelected,
      onSelected: (selected) => onSelected(value),
      selectedColor: limeGreen,
      backgroundColor: const Color(0xFF262626), // Dark chip background
      side: BorderSide(color: isSelected ? limeGreen : Colors.white24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
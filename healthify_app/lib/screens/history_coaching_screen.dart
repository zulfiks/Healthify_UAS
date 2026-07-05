import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryCoachingScreen extends StatefulWidget {
  final int userId;

  const HistoryCoachingScreen({
    super.key,
    required this.userId,
  });

  @override
  State<HistoryCoachingScreen> createState() => _HistoryCoachingScreenState();
}

class _HistoryCoachingScreenState extends State<HistoryCoachingScreen> {
  List<dynamic> history = [];

  // Warna Palette Baru (Dark Mode)
  final Color darkBg = const Color(0xFF181A1F);
  final Color darkCard = const Color(0xFF22252A); // Warna card gelap agar kontras
  final Color darkGreen = const Color(0xFF054A3B);
  final Color limeGreen = const Color(0xFFD2F564);
  final Color lightBlue = const Color(0xFF4AC2C5);

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // ==================== LOGIKA FUNGSI (TIDAK DIUBAH SAMA SEKALI) ====================
  Future<void> loadHistory() async {
    history = await ApiService.getCoachingHistory(widget.userId);
    setState(() {});
  }
  // ==================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg, // Background Hitam Pekat Sesuai Request
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// --- HEADER (Tombol Back & Judul) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Ditambahkan Expanded agar teks otomatis menyesuaikan lebar layar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Riwayat Coaching',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Lihat riwayat hasil coachingmu',
                          style: TextStyle(
                            fontSize: 13, 
                            color: Colors.white.withValues(alpha:0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- KARTU TOP BANNER (Total Coaching) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: darkGreen, // Background Hijau Tua
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  // Icon Dokumen di Lingkaran Stabilo
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: limeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.assignment_turned_in_rounded, color: darkBg, size: 30),
                  ),
                  const SizedBox(width: 16),
                  
                  // Teks Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Coaching',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${history.length}',
                              style: TextStyle(color: limeGreen, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1),
                            ),
                            Text(
                              'x',
                              style: TextStyle(color: limeGreen, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Terakhir update hari ini',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  
                  // Ilustrasi Ikon Kanan
                  const Icon(Icons.insert_chart_outlined, color: Colors.white24, size: 60),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- TOMBOL FILTER "Semua Waktu" ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Semua Waktu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- LIST RIWAYAT COACHING ---
            Expanded(
              child: history.isEmpty
                  ? Center(child: Text("Belum ada riwayat coaching.", style: TextStyle(color: Colors.white.withValues(alpha:0.6))))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      itemCount: history.length + 1, // +1 untuk banner Tips di paling bawah
                      itemBuilder: (context, index) {
                        
                        // Banner Tips Sehat di akhir list (Sesuai gambar referensi)
                        if (index == history.length) {
                          return _buildTipsCard();
                        }

                        // Mengambil Data dari API Sesuai Logika Asli
                        final item = history[index];
                        String title = item['template']?['title'] ?? 'No Title';
                        String message = item['template']?['message'] ?? 'No Message';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: darkCard, // Background card abu-abu gelap
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              // Ikon Kiri
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: darkGreen.withValues(alpha:0.5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(Icons.monitor_heart_outlined, color: lightBlue, size: 26),
                              ),
                              const SizedBox(width: 16),
                              
                              // Informasi (Title & Message)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      message,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha:0.6),
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Ikon Panah Kanan
                              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha:0.3)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tambahan Untuk Tips Sehat (Bagian paling bawah di gambar)
  Widget _buildTipsCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkGreen.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: darkGreen.withValues(alpha:0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: darkBg,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb_outline, color: limeGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Rutin',
                  style: TextStyle(fontWeight: FontWeight.w800, color: limeGreen, fontSize: 15),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Baca pesan coachingmu secara rutin untuk mendapatkan hasil yang optimal.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
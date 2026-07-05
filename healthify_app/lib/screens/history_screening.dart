import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryScreeningPage extends StatefulWidget {
  final int userId;

  const HistoryScreeningPage({
    super.key,
    required this.userId,
  });

  @override
  State<HistoryScreeningPage> createState() => _HistoryScreeningPageState();
}

class _HistoryScreeningPageState extends State<HistoryScreeningPage> {
  List<dynamic> histories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final result = await ApiService.getScreeningHistory(
      widget.userId,
    );

    setState(() {
      histories = result;
      isLoading = false;
    });
  }

  // Helper untuk warna teks klasifikasi (support Bahasa Inggris & Indonesia)
  Color _getKlasifikasiColor(String classification) {
    String c = classification.toLowerCase();
    if (c.contains('normal')) return Colors.greenAccent;
    if (c.contains('overweight')) return const Color(0xFF4DB6AC); // Cyan
    if (c.contains('obesitas') || c.contains('obesity')) return const Color(0xFFFFB74D); // Peach/Orange
    return Colors.white;
  }

  // Helper untuk warna background & teks risk level (support Bahasa Inggris & Indonesia)
  Color _getRiskColor(String risk) {
    String r = risk.toLowerCase();
    if (r.contains('rendah') || r.contains('low')) return Colors.greenAccent;
    if (r.contains('sedang') || r.contains('moderate')) return Colors.yellow;
    if (r.contains('tinggi') || r.contains('high')) return Colors.deepOrangeAccent;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // Tombol kalender di pojok kanan atas sudah dihapus
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFC7F464)),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Title ---
                  const Text(
                    "Riwayat Screening",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Lihat riwayat hasil screeningmu",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Summary Card (Total Screening) ---
                  Container(
                    padding: const EdgeInsets.all(16),
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
                            Icons.receipt_long,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Screening",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${histories.length}x",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Terakhir update hari ini",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.fact_check,
                          color: Colors.white24,
                          size: 60,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Dropdown Filter Semua Waktu ---
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        "Semua Waktu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- List View Data ---
                  Expanded(
                    child: ListView.builder(
                      itemCount: histories.length,
                      itemBuilder: (context, index) {
                        final item = histories[index];

                        final bmiValue = item['imt_value']?.toString() ?? '-';
                        final classification = item['imt_classification']?.toString() ?? '-';
                        final riskLevel = item['risk_level']?.toString() ?? '-';
                        final fullDate = item['created_at']?.toString() ?? '';
                        
                        String displayDate = fullDate;
                        String displayTime = '';
                        if (fullDate.length >= 10) {
                          displayDate = fullDate.substring(0, 10);
                          if (fullDate.length >= 16) {
                            displayTime = fullDate.substring(11, 16);
                          }
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161616),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              // Icon Sebelah Kiri
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E3329),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  index % 2 == 0 ? Icons.monitor_weight : Icons.favorite,
                                  color: const Color(0xFF4DB6AC),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Kolom Data Tengah (Diperbaiki agar tidak overflow)
                              Expanded(
                                child: Row(
                                  children: [
                                    // Kolom BMI
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("BMI", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                          const SizedBox(height: 4),
                                          Text(
                                            bmiValue,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis, // Mencegah tulisan memanjang keluar batas
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16, // Ukuran disesuaikan sedikit
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Kolom Klasifikasi
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Klasifikasi", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                          const SizedBox(height: 4),
                                          Text(
                                            classification,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _getKlasifikasiColor(classification),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Kolom Risk Level
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Risk Level", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getRiskColor(riskLevel).withValues(alpha:0.15),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              riskLevel,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                              color: _getRiskColor(riskLevel),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Tanggal & Waktu (Icon > sudah dihapus)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    displayDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    displayTime,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
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
}
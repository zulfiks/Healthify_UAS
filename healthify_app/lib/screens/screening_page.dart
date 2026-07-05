import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class ScreeningPage extends StatefulWidget {
  final int userId;

  const ScreeningPage({
    super.key,
    required this.userId,
  });

  @override
  State<ScreeningPage> createState() => _ScreeningPageState();
}

class _ScreeningPageState extends State<ScreeningPage> {
  final _formKey = GlobalKey<FormState>();

  // BODY DATA
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _waistCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();

  String _gender = 'male';

  // STEP
  int _currentStep = 0;

  // LIFESTYLE
  String _activityLevel = '';
  String _sweetDrink = '';
  String _fastFood = '';
  String _sleepDuration = '';
  String _sittingDuration = '';
  String _fatigue = '';

  // CONDITIONS
  final List<String> _conditions = [];

  bool _isSubmitting = false;

  // =========================
  // SUBMIT SCREENING
  // =========================

  Future<void> _submitScreening() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/screening'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          // BODY
          'user_id': widget.userId,
          'weight': double.tryParse(_weightCtrl.text) ?? 0,
          'height': double.tryParse(_heightCtrl.text) ?? 0,
          'waist': double.tryParse(_waistCtrl.text) ?? 0,
          'age': int.tryParse(_ageCtrl.text) ?? 0,
          'gender': _gender,

          // LIFESTYLE
          'activity_level': _activityLevel,
          'sweet_drink': _sweetDrink,
          'fast_food': _fastFood,
          'sleep_duration': _sleepDuration,
          'sitting_duration': _sittingDuration,
          'fatigue': _fatigue,

          // CONDITIONS
          'conditions': _conditions,
        }),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      // =========================
      // SUCCESS
      // =========================

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final result = decoded['data'];

        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: const Color(0xFF161616), // Dark background for dialog
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Dialog
                      const Text(
                        "Hasil Analisis Kesehatan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Success Icon Check
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7F464).withValues(alpha:0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC7F464),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Screening berhasil",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Berikut adalah ringkasan hasil\nanalisis kesehatanmu",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Grid Layout untuk Hasil agar tidak terpotong
                      Row(
                        children: [
                          Expanded(
                            child: _buildDialogResultCard(
                              title: "BMI",
                              value: result['imt_value']?.toString() ?? '-',
                              subValue: result['imt_classification']?.toString() ?? '',
                              icon: Icons.monitor_weight,
                              subValueColor: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
  child: _buildDialogResultCard(
    title: "Tingkat Risiko",
    value: result['risk_level']?.toString() ?? '-',
    subValue: "",
    icon: Icons.shield,
    subValueColor: Colors.greenAccent,
  ),
),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDialogResultCard(
                              title: "Obesitas Sentral",
                              value: result['central_obesity_status']?.toString() ?? '-',
                              subValue: "",
                              icon: Icons.straighten,
                              subValueColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDialogResultCard(
                              title: "Status Kesehatan",
                              value: "Selesai", // Fallback info
                              subValue: "",
                              icon: Icons.favorite,
                              subValueColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Info AI Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3329),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFF4DB6AC)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "AI sedang menyiapkan rekomendasi personal berdasarkan hasil screening kamu.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Button Selesai
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF114232),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Selesai",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        // FAILED RESPONSE
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data (${response.statusCode})")),
        );
      }
    } catch (e) {
      // ERROR
      debugPrint("ERROR SCREENING: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // =========================
  // UI WIDGET HELPERS
  // =========================

  Widget _buildDialogResultCard({
    required String title,
    required String value,
    required String subValue,
    required IconData icon,
    required Color subValueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Lighter dark grey
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (subValue.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subValue,
                        style: TextStyle(
                          color: subValueColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3329),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF4DB6AC), size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(0, "Data Tubuh"),
        _buildStepLine(0),
        _buildStepCircle(1, "Gaya Hidup"),
        _buildStepLine(1),
        _buildStepCircle(2, "Kesehatan"),
      ],
    );
  }

  Widget _buildStepCircle(int stepIndex, String title) {
    bool isActive = _currentStep >= stepIndex;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFC7F464) : const Color(0xFF161616),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? const Color(0xFFC7F464) : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              "${stepIndex + 1}",
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  Widget _buildStepLine(int stepIndex) {
    bool isActive = _currentStep > stepIndex;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20), // Align with circles
        height: 2,
        color: isActive ? const Color(0xFFC7F464) : Colors.white24,
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF161616),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3329),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF4DB6AC), size: 20),
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget _buildDropdownQuestion(String title, String hint, IconData icon, Color iconBg, List<String> options, String selectedValue, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: const Color(0xFF262626),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                    hint: Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    value: selectedValue.isEmpty ? null : selectedValue,
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) onChanged(val);
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

  // =========================
  // UI MAIN BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header Bagian Atas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Screening\nKesehatan",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Isi data berikut untuk analisis kesehatanmu",
                            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3329),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.assignment, size: 50, color: Color(0xFF4DB6AC)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Stepper Custom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: _buildStepIndicator(),
              ),
              const SizedBox(height: 20),

              // Area Konten Form Berdasarkan Step
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- STEP 1: DATA TUBUH ---
                      if (_currentStep == 0) ...[
                        const Row(
                          children: [
                            Icon(Icons.person, color: Color(0xFF4DB6AC)),
                            SizedBox(width: 8),
                            Text("Data Tubuh", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("Masukkan data tubuhmu dengan benar", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 20),

                        _buildTextField(_weightCtrl, "Berat Badan (kg)", "Contoh: 70", Icons.monitor_weight),
                        _buildTextField(_heightCtrl, "Tinggi Badan (cm)", "Contoh: 170", Icons.height),
                        _buildTextField(_waistCtrl, "Lingkar Pinggang (cm)", "Contoh: 80", Icons.straighten),
                        _buildTextField(_ageCtrl, "Usia (tahun)", "Contoh: 25", Icons.calendar_today),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Jenis Kelamin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _gender = 'male'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _gender == 'male' ? const Color(0xFFC7F464).withValues(alpha:0.2) : const Color(0xFF161616),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: _gender == 'male' ? const Color(0xFFC7F464) : Colors.transparent),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.male, color: _gender == 'male' ? const Color(0xFFC7F464) : Colors.white54, size: 30),
                                      const SizedBox(height: 8),
                                      Text("Laki-laki", style: TextStyle(color: _gender == 'male' ? const Color(0xFFC7F464) : Colors.white54, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _gender = 'female'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _gender == 'female' ? const Color(0xFFC7F464).withValues(alpha:0.2) : const Color(0xFF161616),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: _gender == 'female' ? const Color(0xFFC7F464) : Colors.transparent),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.female, color: _gender == 'female' ? const Color(0xFFC7F464) : Colors.white54, size: 30),
                                      const SizedBox(height: 8),
                                      Text("Perempuan", style: TextStyle(color: _gender == 'female' ? const Color(0xFFC7F464) : Colors.white54, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // --- STEP 2: GAYA HIDUP ---
                      if (_currentStep == 1) ...[
                        const Row(
                          children: [
                            Icon(Icons.favorite, color: Color(0xFF4DB6AC)),
                            SizedBox(width: 8),
                            Text("Gaya Hidup", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("Ceritakan kebiasaan sehari-harimu", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 20),

                        _buildDropdownQuestion("Aktivitas Fisik per Minggu", "Pilih frekuensi aktivitas fisik", Icons.directions_run, const Color(0xFFC7F464), ["Sering", "Kadang", "Jarang"], _activityLevel, (v) => setState(() => _activityLevel = v)),
                        _buildDropdownQuestion("Frekuensi Konsumsi Minuman Manis", "Pilih frekuensi konsumsi", Icons.local_cafe, const Color(0xFFFFCC80), ["Sering", "Kadang", "Jarang"], _sweetDrink, (v) => setState(() => _sweetDrink = v)),
                        _buildDropdownQuestion("Frekuensi Konsumsi Makanan Cepat Saji", "Pilih frekuensi konsumsi", Icons.fastfood, const Color(0xFFC7F464), ["Sering", "Kadang", "Jarang"], _fastFood, (v) => setState(() => _fastFood = v)),
                        _buildDropdownQuestion("Durasi Tidur per Hari", "Pilih rata-rata durasi tidur", Icons.bedtime, const Color(0xFF80CBC4), ["<5 jam", "6-7 jam", ">7 jam"], _sleepDuration, (v) => setState(() => _sleepDuration = v)),
                        _buildDropdownQuestion("Lama Duduk dalam Sehari", "Pilih rata-rata durasi duduk", Icons.chair, const Color(0xFFFFE082), ["Ya", "Kadang", "Tidak"], _sittingDuration, (v) => setState(() => _sittingDuration = v)),
                        _buildDropdownQuestion("Seberapa Sering Anda Merasa Mudah Lelah?", "Pilih kondisi yang paling sesuai", Icons.sick, const Color(0xFFFFAB91), ["Ya", "Kadang", "Tidak"], _fatigue, (v) => setState(() => _fatigue = v)),
                      ],

                      // --- STEP 3: RIWAYAT KESEHATAN (Opsional) ---
                      if (_currentStep == 2) ...[
                        const Row(
                          children: [
                            Icon(Icons.medical_services, color: Color(0xFF4DB6AC)),
                            SizedBox(width: 8),
                            Text("Kondisi Kesehatan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("Pilih jika ada riwayat (Opsional)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 20),

                        ...[
                          {"label": "Hipertensi", "value": "hypertension"},
                          {"label": "Diabetes", "value": "diabetes"},
                          {"label": "Kolesterol", "value": "cholesterol"},
                          {"label": "Nyeri Sendi", "value": "joint_pain"},
                        ].map((item) {
                          bool isChecked = _conditions.contains(item["value"]);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161616),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: CheckboxListTile(
                              title: Text(item["label"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              activeColor: const Color(0xFFC7F464),
                              checkColor: Colors.black,
                              side: const BorderSide(color: Colors.white54),
                              value: isChecked,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _conditions.add(item["value"]!);
                                  } else {
                                    _conditions.remove(item["value"]!);
                                  }
                                });
                              },
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation & Buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep--;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text("Kembali", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    if (_currentStep < 2) {
                                      // Cek validasi form khusus jika di Step 1
                                      if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
                                      setState(() {
                                        _currentStep++;
                                      });
                                    } else {
                                      _submitScreening();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF114232), // Dark Green
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Color(0xFFC7F464), strokeWidth: 2),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _currentStep == 2 ? "Analisis" : "Selanjutnya",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(color: Color(0xFFC7F464), shape: BoxShape.circle),
                                        child: const Icon(Icons.chevron_right, color: Colors.black, size: 16),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, color: Colors.grey, size: 14),
                        SizedBox(width: 6),
                        Text("Data kamu aman dan terlindungi", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk mendeteksi kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart'; // Sesuaikan dengan login screen Anda
import 'screening_page.dart';
import 'history_screening.dart';
import '../services/api_service.dart'; // Import ApiService bawaan Anda
 // Sesuaikan dengan nama file riwayat Anda

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  File? _imageFile;          // Untuk handle di Mobile (Android/iOS)
  Uint8List? _webImageBytes; // KHUSUS WEB: Menyimpan data gambar dalam bentuk memori bytes
  XFile? _pickedFile;        // Menyimpan mentahan file gambar yang dipilih untuk diupload nanti
  
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _waController = TextEditingController();
  bool _isImageChanged = false; // Penanda apakah ada foto baru yang belum disimpan
  Map<String, dynamic>? latestScreening;

  // Warna Palette Baru (Sesuai Referensi)
  final Color darkBg = const Color(0xFF181A1F);
  final Color darkGreen = const Color(0xFF054A3B);
  final Color limeGreen = const Color(0xFFD2F564);
  final Color lightBlue = const Color(0xFF4AC2C5);
  final Color peach = const Color(0xFFF7B19C);
  final Color bgLight = const Color(0xFFF8FAF9);

  @override
  void initState() {
    super.initState();
    _loadLatestScreening();
  }

  // ==================== LOGIKA FUNGSI (TIDAK DIUBAH SAMA SEKALI) ====================
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (selected != null) {
        if (kIsWeb) {
          final Uint8List bytes = await selected.readAsBytes();
          setState(() {
            _webImageBytes = bytes;
            _imageFile = null;
            _pickedFile = selected;
            _isImageChanged = true; 
          });
        } else {
          setState(() {
            _imageFile = File(selected.path);
            _webImageBytes = null;
            _pickedFile = selected;
            _isImageChanged = true; 
          });
        }
      }
    } catch (e) {
      debugPrint("Error mengambil gambar: $e");
    }
  }

  Future<void> _simpanFotoKeBackend() async {
    if (widget.userData == null || widget.userData!['id'] == null || _pickedFile == null) return;

    setState(() => _isSaving = true);

    try {
      String? uploadedUrl = await ApiService.uploadProfilePicture(
        widget.userData!['id'], 
        _pickedFile!,
      );

      if (mounted) {
        setState(() => _isSaving = false);
        
        if (uploadedUrl != null) {
          setState(() {
            widget.userData!['profile_picture'] = uploadedUrl;
            _isImageChanged = false; 
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Foto profil berhasil disimpan permanen!', style: TextStyle(color: Color(0xFF181A1F), fontWeight: FontWeight.bold)), 
              backgroundColor: limeGreen
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan foto ke server.'), 
              backgroundColor: Colors.red
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        debugPrint("Error saving image: $e");
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Ganti Foto Profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: darkBg),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: lightBlue.withValues(alpha:0.2), shape: BoxShape.circle),
                  child: Icon(Icons.photo_library_rounded, color: darkBg),
                ),
                title: const Text('Pilih dari Galeri', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: lightBlue.withValues(alpha:0.2), shape: BoxShape.circle),
                  child: Icon(Icons.camera_alt_rounded, color: darkBg),
                ),
                title: const Text('Ambil dari Kamera', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog() {
    _nameController.text = widget.userData?['name'] ?? '';
    _emailController.text = widget.userData?['email'] ?? '';
    _waController.text = widget.userData?['whatsapp_number'] ?? '';

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
  backgroundColor: const Color(0xFF22252A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            "Edit Profil",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField("Nama", _nameController),
                const SizedBox(height: 16),
                _buildDialogTextField("Email", _emailController),
                const SizedBox(height: 16),
                _buildDialogTextField("Nomor WhatsApp", _waController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: limeGreen,
                foregroundColor: darkBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                bool success = await ApiService.updateProfile(
                  widget.userData!['id'],
                  _nameController.text,
                  _emailController.text,
                  _waController.text,
                );

                if(success){
                  setState(() {
                    widget.userData!['name'] = _nameController.text;
                    widget.userData!['email'] = _emailController.text;
                    widget.userData!['whatsapp_number'] = _waController.text;
                  });
                  if(!mounted) return;
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  Widget _buildDialogTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
  color: Colors.white,
),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
  color: Colors.white70,
),
        filled: true,
        fillColor: const Color(0xFF2C3138),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: darkGreen)),
      ),
    );
  }

  Future<void> _loadLatestScreening() async {
    final response = await ApiService.getLatestScreening(widget.userData!['id']);
    if(response != null){
      setState(() {
        latestScreening = response['data'];
      });
    }
  }
  void _showDeleteAccountDialog() {

  showDialog(

    context: context,

    builder: (_) {

      return AlertDialog(

        backgroundColor:
            const Color(0xFF22252A),

        title: const Text(
          "Hapus Akun Permanen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        content: const Text(
          "Semua data akun akan dihapus permanen termasuk riwayat makanan, screening, aktivitas, report dan data lainnya.\n\nTindakan ini tidak dapat dibatalkan.",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(context);

            },

            child: const Text(
              "Batal",
            ),

          ),

          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),

            onPressed: () async {

              bool success =
                  await ApiService.deleteAccount(
                widget.userData!['id'],
              );

              if (!mounted) return;

              if (success) {

                Navigator.pushAndRemoveUntil(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const LoginScreen(),

                  ),

                  (route) => false,

                );

              }

            },

            child: const Text(
              "Hapus Akun",
            ),

          ),

        ],

      );

    },

  );
}
  // ==================================================================================

  @override
  Widget build(BuildContext context) {
    String userName = widget.userData?['name'] ?? 'Guest';
    String email = widget.userData?['email'] ?? 'guest@email.com';
    String statusRisiko = latestScreening?['risk_level'] ?? 'Belum ada data';
    String? profilePictureUrl = widget.userData?['profile_picture'];
    
    String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    bool hasLocalImage = (kIsWeb && _webImageBytes != null) || (!kIsWeb && _imageFile != null);

    return Scaffold(
      backgroundColor: darkBg, // HANYA UBAH BACKGROUND JADI HITAM PEKAT
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.pop(context, widget.userData?['profile_picture']);
        },
        child: Stack(
          children: [
            // ======== KREASI BACKGROUND ========
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: lightBlue.withValues(alpha:0.15), shape: BoxShape.circle),
              ),
            ),
            // ===================================

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 120), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER DENGAN TOMBOL BACK ---
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context, widget.userData?['profile_picture']),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
  color: darkGreen,
  shape: BoxShape.circle,
),

child: Icon(
  Icons.arrow_back,
  color: limeGreen,
),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Profile',
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white), // Teks putih
                              ),
                              Text(
                                'Kelola informasi akun dan kesehatanmu',
                                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha:0.7)), // Teks putih transparan
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- KARTU PROFIL ATAS (Foto & Nama) -> WARNA HIJAU TUA (DARK GREEN) ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: darkGreen, // Background Hijau Tua
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: darkGreen.withValues(alpha:0.3), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Row(
                        children: [
                          // Foto Profil Stack
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: limeGreen.withValues(alpha:0.2), // Biar nyambung sama ijo tua
                                ),
                                child: ClipOval(
                                  child: hasLocalImage
    ? (kIsWeb
        ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
        : Image.file(_imageFile!, fit: BoxFit.cover))
    : (profilePictureUrl != null && profilePictureUrl.isNotEmpty
        ? Image.network(
            "$profilePictureUrl?${DateTime.now().millisecondsSinceEpoch}",
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) {
              return Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    color: limeGreen,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text(
              initial,
              style: TextStyle(
                color: limeGreen,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          ),
          ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _isSaving ? null : _showImageSourcePicker,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: limeGreen, // Tombol kamera stabilo
                                      shape: BoxShape.circle,
                                      border: Border.all(color: darkGreen, width: 2), // Border mengikuti bg luar
                                    ),
                                    child: Icon(Icons.camera_alt_rounded, color: darkBg, size: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 16),
                          
                          // Informasi Nama & Tombol Simpan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Teks diubah putih
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: limeGreen.withValues(alpha:0.2), // Background transparan stabilo
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Active Member',
                                    style: TextStyle(color: limeGreen, fontSize: 11, fontWeight: FontWeight.w800), // Teks stabilo
                                  ),
                                ),
                                
                                // Muncul jika foto diganti
                                if (_isImageChanged) ...[
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: _isSaving ? null : _simpanFotoKeBackend,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(color: limeGreen, borderRadius: BorderRadius.circular(12)),
                                      child: _isSaving
                                          ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                          : Text('Simpan Foto', style: TextStyle(color: darkBg, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // --- INFORMASI AKUN ---
                    const Text('Informasi Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)), // Teks putih
                    const SizedBox(height: 12),
                    
                    // --- KARTU INFORMASI AKUN (BAWAH) -> WARNA HIJAU MUDA (LIME GREEN) ---
                   Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22252A),
                      borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: limeGreen.withValues(alpha:0.3), blurRadius: 15, offset: const Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildModernInfoTile(Icons.person_outline, 'Nama Lengkap', userName),
                          _buildDivider(),
                          _buildModernInfoTile(Icons.email_outlined, 'Alamat Email', email),
                          _buildDivider(),
                          _buildModernInfoTile(Icons.phone_outlined, 'No. WhatsApp', widget.userData?['whatsapp_number'] ?? '-'),
                          _buildDivider(),
                          _buildModernInfoTile(Icons.health_and_safety_outlined, 'Risiko', statusRisiko),
                          _buildDivider(),
                          
                          _buildDivider(),
                          
_buildDivider(),

_buildModernInfoTile(
  Icons.wc,
  'Jenis Kelamin',
  latestScreening?['gender'] == 'male'
      ? 'Laki-laki'
      : latestScreening?['gender'] == 'female'
          ? 'Perempuan'
          : '-',
),

_buildDivider(),

_buildModernInfoTile(
  Icons.cake_outlined,
  'Usia',
  '${latestScreening?['age'] ?? '-'} tahun',
),

_buildDivider(),

_buildModernInfoTile(
  Icons.height,
  'Tinggi Badan',
  '${latestScreening?['height'] ?? '-'} cm',
),

_buildDivider(),

_buildModernInfoTile(
  Icons.monitor_weight_outlined,
  'Berat Badan',
  '${latestScreening?['weight'] ?? '-'} kg',
),

_buildDivider(),
                          
                          // Desain Khusus BMI Terakhir Menyatu dengan List
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
  color: darkGreen.withValues(alpha:0.5),
  shape: BoxShape.circle,
),
child: Icon(
  Icons.monitor_weight_outlined,
  color: limeGreen,
  size: 20,
),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('BMI Terakhir', style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '${latestScreening?['imt_value'] ?? '-'}',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(color: darkGreen.withValues(alpha:0.5), borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              latestScreening?['imt_classification'] ?? '-',
                                              style: TextStyle(color: darkGreen, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
  margin: const EdgeInsets.symmetric(horizontal: 12),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: darkGreen.withValues(alpha:0.3),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        Icons.info_outline,
        color: limeGreen,
      ),
      const SizedBox(width: 12),

      Expanded(
        child: Text(
          'Data jenis kelamin, usia, tinggi badan, dan berat badan berasal dari hasil screening terakhir. Untuk memperbarui data kesehatan tersebut, lakukan screening ulang agar BMI dan tingkat risiko diperbarui secara otomatis.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ),
    ],
  ),
),

                          // Tombol Edit Profil di Bawah Form (Warna Kontras)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _showEditProfileDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkBg, // Background tombol hitam di atas form lime green
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text('Edit Profil', style: TextStyle(color: limeGreen, fontWeight: FontWeight.bold)), // Teks stabilo
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // --- AKTIVITAS KESEHATAN (2 Kotak Sampingan) ---
                    const Text('Aktivitas Kesehatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)), // Teks putih
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // KOTAK 1: Update Data Screening
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
  backgroundColor: const Color(0xFF22252A),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    title: const Text(
  "Perbarui Data",
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
),
                                    content: const Text(
  "Screening baru akan memperbarui BMI terbaru dan menambahkan riwayat baru.",
  style: TextStyle(
    color: Colors.white70,
    height: 1.5,
  ),
),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: limeGreen, foregroundColor: darkBg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => ScreeningPage(userId: widget.userData!['id'])),
                                          ).then((_) => _loadLatestScreening());
                                        },
                                        child: const Text("Lanjut", style: TextStyle(fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  );
                                }
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: limeGreen.withValues(alpha:0.3),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: darkGreen, shape: BoxShape.circle),
                                    child: const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Update Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)), // Teks Putih
                                  Text('Screening Baru', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha:0.7))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // KOTAK 2: Riwayat Screening
Expanded(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HistoryScreeningPage(userId: widget.userData!['id']),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A44),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: limeGreen.withValues(alpha:0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_edu_rounded,
              color: limeGreen,
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Riwayat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Text(
            'Lihat Hasil',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha:0.7),
            ),
          ),
        ],
      ),
    ),
  ),
),
],
),
                    const SizedBox(height: 32),

                    // --- TOMBOL LOGOUT ---
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A1F28),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, color: Color(0xFFFF8FA3), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Keluar Akun',
                              style: TextStyle(color: Color(0xFFFF8FA3), fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  height: 56,

  child: ElevatedButton(

    style: ElevatedButton.styleFrom(

      backgroundColor: const Color(
        0xFF4A1B1B,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),

    ),

    onPressed: () {

      _showDeleteAccountDialog();

    },

    child: const Row(

      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Icon(
          Icons.delete_forever_rounded,
          color: Colors.redAccent,
        ),

        SizedBox(width: 10),

        Text(
          "Delete Account",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    ),
  ),
),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk List Tile Modern di Informasi Akun (Disesuaikan untuk Background Hijau Muda)
  Widget _buildModernInfoTile(IconData icon, String title, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: darkGreen.withValues(alpha:0.5),
    shape: BoxShape.circle,
  ),
  child: Icon(
    icon,
    color: limeGreen,
    size: 20,
  ),
), // INI YANG HILANG

const SizedBox(width: 16),

Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800, // Teks value ditebalkan
                    color: Colors.white, // Teks gelap pekat karena backgroundnya hijau terang
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 12),
      child: Divider(height: 1, color: darkGreen.withValues(alpha:0.1)), // Garis pemisah tipis berwarna gelap
    );
  }
}
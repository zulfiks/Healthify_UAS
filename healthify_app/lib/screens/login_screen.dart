import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import 'expert/expert_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // ================= ACTION LOGIN (TIDAK BERUBAH SAMA SEKALI) =================
  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Email dan Password tidak boleh kosong', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.loginUser(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

if (result['success']) {

  final user = result['data'];

  if (user['role'] == 'expert') {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ExpertDashboardScreen(),
      ),
    );

  } else {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          userData: user,
        ),
      ),
    );

  }

}else {
      _showSnackBar(result['message'], Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
  // ==============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- BACKGROUND DIUBAH MENJADI HITAM ---
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Bawah (Menggunakan gambar aslinya agar persis 100%)
          Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bottom_wave.png',
              height: 120,
              width: MediaQuery.of(context).size.width, // Pastikan nama file gambar ombak daun disesuaikan
              fit: BoxFit.cover,
alignment: Alignment.bottomCenter,
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
    MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      
                    // Header Section (Welcome Back & Illustration)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 20),
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                  // Warna disesuaikan agar terlihat di background hitam
                                  color: Color(0xFFD2F564), 
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Text(
                                'Back!',
                                style: TextStyle(
                                  // Warna disesuaikan agar terlihat di background hitam
                                  color: Colors.white, 
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Track your health journey\nand continue your\nprogress with Healthify',
                                style: TextStyle(
                                  // Warna disesuaikan agar terlihat di background hitam
                                  color: Colors.white70, 
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Illustration Image
                        Image.asset(
                          'assets/images/login_illustration.png',
                          width: 145,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Input Field Email
                    const Text(
                      'Email',
                      style: TextStyle(
                        // Warna disesuaikan agar terlihat di background hitam
                        color: Colors.white, 
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        // Warna teks inputan disesuaikan
                        color: Colors.white, 
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        // Hint text disesuaikan
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14), 
                        // Icon disesuaikan
                        prefixIcon: const Icon(Icons.mail_outline, color: Colors.white54), 
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD2F564), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Field Password
                    const Text(
                      'Password',
                      style: TextStyle(
                        // Warna disesuaikan agar terlihat di background hitam
                        color: Colors.white, 
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        // Warna teks inputan disesuaikan
                        color: Colors.white, 
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        // Hint text disesuaikan
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14), 
                        // Icon disesuaikan
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54), 
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white54, // Icon disesuaikan
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD2F564), width: 1.5),
                        ),
                      ),
                    ),
                    
                    // --- TULISAN FORGOT PASSWORD DIHAPUS ---
                
                    const SizedBox(height: 28),

                    // Sign In Button (Lime Green) - TIDAK DIUBAH (Tetap Lime)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD2F564), // Warna lime green
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // SizedBox ini digunakan agar posisi teks tetap di tengah (seimbang dengan tombol bulat di kanan)
                                  const SizedBox(width: 32),
                                  const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF181A1F),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24), // Jarak antara Sign In button dengan Sign Up Link

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            // Warna disesuaikan agar terlihat di background hitam
                            color: Colors.white70, 
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              // Warna Sign Up diganti ke Lime agar kontras di hitam
                              color: Color(0xFFD2F564), 
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // MEMBERI RUANG SCROLL EXTRA BESAR DI BAWAH AGAR TEKS TIDAK TERTUTUP BACKGROUND WAVE
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          )
        ],
      ),
    );
  }
}
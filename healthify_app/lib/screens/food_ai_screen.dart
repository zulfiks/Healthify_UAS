import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart'
    as stt;
import 'package:permission_handler/permission_handler.dart';

import '../models/food_ai_model.dart';
import '../services/api_service.dart';
import '../widgets/food_input_card.dart';
import '../widgets/food_ai_result_card.dart';


class FoodAIScreen extends StatefulWidget {
  final int userId;

  const FoodAIScreen({
    super.key,
    required this.userId,
  });

  @override
  State<FoodAIScreen> createState() => _FoodAIScreenState();
}

class _FoodAIScreenState extends State<FoodAIScreen> {
  final TextEditingController _controller = TextEditingController();
late stt.SpeechToText _speech;

bool isListening = false;
  FoodAIResponse? _response;

  bool _loading = false;

  String? _error;

  // --- UI COLORS CONSTANTS ---
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color greenColor = const Color(0xFFC7F464);

  Future<void> _analyzeFood() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _response = null;
    });

    final result = await ApiService.parseFoodAI(
      widget.userId,
      _controller.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;

      if (result != null) {
        _response = result;
      } else {
        _error = 'Gagal menganalisis makanan.';
      }
    });
  }

  Future<void> startListening() async {

await Permission.microphone.request();

bool available =
    await _speech.initialize();

  if (!available) return;

  setState(() {

    isListening = true;

  });

  _speech.listen(

    localeId: "id_ID",

    onResult: (result) {

  setState(() {

    _controller.text =
        result.recognizedWords;

    if (result.finalResult) {

      isListening = false;

    }

  });

},

  );

}
Future<void> stopListening() async {

  await _speech.stop();

  setState(() {

    isListening = false;

  });

}

@override
void initState() {

  super.initState();

  _speech = stt.SpeechToText();

}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Membungkus dengan Theme Dark agar widget eksternal (FoodInputCard & Result) ikut menjadi gelap
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        cardColor: cardColor,
        colorScheme: ColorScheme.dark(
          primary: greenColor,
          surface: cardColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "AI Food Analysis",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: 0.5,
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              // HEADER ICON
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: greenColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: greenColor,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // WIDGET INPUT EKSTERNAL
              FoodInputCard(
                controller: _controller,
                onAnalyze: _analyzeFood,
                loading: _loading,
              ),
const SizedBox(
  height: 15,
),

ElevatedButton.icon(

  icon: Icon(

    isListening

        ? Icons.mic

        : Icons.mic_none,

  ),

  label: Text(

    isListening

        ? "Stop"

        : "Input dengan Suara",

  ),

  onPressed: () {

    if (isListening) {

      stopListening();

    } else {

      startListening();

    }

  },

),
              const SizedBox(height: 24),

              // LOADING STATE
              if (_loading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: greenColor),
                  ),
                ),

              // ERROR STATE
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // RESULT STATE
              if (_response != null) ...[
                // WIDGET HASIL EKSTERNAL
                FoodAIResultCard(
                  response: _response!,
                ),

                const SizedBox(height: 24),

                // TOMBOL SIMPAN
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bentuk Pill
                      ),
                    ),
                    icon: const Icon(Icons.save_rounded, size: 22),
                    label: const Text(
                      "Simpan ke Jurnal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    onPressed: () async {
                      // LOGIKA FUNGSI ASLI - TIDAK DIUBAH
                      final firstFood = _response!.foods.first;

                      if (firstFood.foodId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: cardColor,
                            content: const Text(
                              "Makanan tidak ada di database sehingga belum bisa disimpan.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        return;
                      }

                      final success = await ApiService.saveFoodLog(
                        widget.userId,
                        firstFood.foodId!,
                        1,
                        firstFood.calories,
                      );

                      if (!mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: greenColor,
                            content: const Text(
                              "Berhasil disimpan ke jurnal 🎉",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                              "Gagal menyimpan.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
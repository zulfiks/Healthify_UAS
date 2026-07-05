import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ExpertReviewScreen extends StatefulWidget {
  final int userId;

  const ExpertReviewScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ExpertReviewScreen> createState() => _ExpertReviewScreenState();
}

class _ExpertReviewScreenState extends State<ExpertReviewScreen> {
  bool isLoading = true;
  Map<String, dynamic>? reviewData;

  final TextEditingController expertNameController = TextEditingController();
  final TextEditingController expertNoteController = TextEditingController();
  final TextEditingController mealPlanController = TextEditingController();

  String status = "approved";
  int? reviewId;

  // --- UI COLORS CONSTANTS ---
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color inputColor = const Color(0xFF222222);
  final Color greenColor = const Color(0xFFC7F464);

  @override
  void initState() {
    super.initState();
    loadReview();
  }

  Future<void> loadReview() async {
    setState(() {
      isLoading = true;
    });

    final data = await ApiService.getExpertReview(widget.userId);

    if (data != null) {
      reviewData = data;
      if (data['expert_review'] != null) {
        reviewId = data['expert_review']['id'];
        expertNameController.text = data['expert_review']['expert_name'] ?? '';
        expertNoteController.text = data['expert_review']['expert_note'] ?? '';
        mealPlanController.text = data['expert_review']['meal_plan'] ?? '';
        status = data['expert_review']['status'] ?? "approved";
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveReview() async {
    bool success;
    if (reviewId == null) {
      success = await ApiService.createExpertReview(
        userId: widget.userId,
        expertName: expertNameController.text,
        expertNote: expertNoteController.text,
        mealPlan: mealPlanController.text,
        status: status,
      );
    } else {
      success = await ApiService.updateExpertReview(
        reviewId: reviewId!,
        expertName: expertNameController.text,
        expertNote: expertNoteController.text,
        mealPlan: mealPlanController.text,
        status: status,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: greenColor,
          content: const Text(
            "Review berhasil disimpan",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      loadReview();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Gagal menyimpan", style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  Future<void> deleteReview() async {
    if (reviewId == null) return;
    final success = await ApiService.deleteExpertReview(reviewId!);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Review berhasil dihapus"),
        ),
      );
      reviewId = null;
      expertNameController.clear();
      expertNoteController.clear();
      mealPlanController.clear();
      loadReview();
    }
  }

  @override
  void dispose() {
    expertNameController.dispose();
    expertNoteController.dispose();
    mealPlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(color: greenColor),
        ),
      );
    }

    final user = reviewData?['user'];
    final screening = reviewData?['screening'];
    final plan = reviewData?['weight_loss_plan'];
    final foods = reviewData?['food_logs'] ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Expert Review",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserCard(user, screening),
            const SizedBox(height: 20),
            _buildWeightLossCard(plan),
            const SizedBox(height: 20),
            _buildFoodHistory(foods),
            const SizedBox(height: 20),
            _buildReviewForm(),
            const SizedBox(height: 40), // Extra padding at bottom
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildUserCard(Map? user, Map? screening) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: greenColor, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.person_rounded, size: 32, color: Colors.white54),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?['name'] ?? '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?['email'] ?? '-',
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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildCustomChip(
                "BMI: ${screening?['imt_value'] ?? '-'}",
                Icons.monitor_weight_outlined,
                greenColor,
              ),
              _buildCustomChip(
                screening?['imt_classification'] ?? 'No Status',
                Icons.analytics_outlined,
                Colors.white,
              ),
              _buildCustomChip(
                "Risk: ${screening?['risk_level'] ?? '-'}",
                Icons.warning_amber_rounded,
                Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightLossCard(Map? plan) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: greenColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                "AI Weight Loss Plan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            plan?['plan_text'] ?? "Tidak ada rekomendasi AI",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodHistory(List foods) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu_rounded, color: greenColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Recent Food Logs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (foods.isEmpty)
            const Text(
              "Belum ada log makanan.",
              style: TextStyle(color: Colors.white54),
            )
          else
            ...foods.take(10).map((food) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: inputColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.fastfood_rounded, color: greenColor, size: 20),
                  ),
                  title: Text(
                    food['food_name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Text(
                    "${food['total_calories']} kcal",
                    style: TextStyle(
                      color: greenColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: greenColor.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_rounded, color: greenColor, size: 22),
              const SizedBox(width: 8),
              const Text(
                "Form Expert Review",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (reviewId != null) ...[
            const Text(
              "Status Review Saat Ini",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: status == "approved"
                    ? Colors.greenAccent.withOpacity(0.15)
                    : status == "revised"
                        ? Colors.orangeAccent.withOpacity(0.15)
                        : Colors.lightBlueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: status == "approved"
                      ? Colors.greenAccent
                      : status == "revised"
                          ? Colors.orangeAccent
                          : Colors.lightBlueAccent,
                ),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: status == "approved"
                      ? Colors.greenAccent
                      : status == "revised"
                          ? Colors.orangeAccent
                          : Colors.lightBlueAccent,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          _buildCustomTextField(
            controller: expertNameController,
            label: "Expert Name",
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 16),
          _buildCustomTextField(
            controller: expertNoteController,
            label: "Expert Note",
            icon: Icons.notes_rounded,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _buildCustomTextField(
            controller: mealPlanController,
            label: "Meal Plan Recommendations",
            icon: Icons.restaurant_menu,
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Dropdown Status
          DropdownButtonFormField<String>(
            value: status,
            dropdownColor: inputColor,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              filled: true,
              fillColor: inputColor,
              labelText: "Review Status",
              labelStyle: const TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.checklist_rounded, color: greenColor, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(value: "approved", child: Text("Approved")),
              DropdownMenuItem(value: "revised", child: Text("Revised")),
              DropdownMenuItem(value: "pending", child: Text("Pending")),
            ],
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),
          const SizedBox(height: 30),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.save_rounded, size: 20),
                  label: const Text(
                    "Save Review",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  onPressed: saveReview,
                ),
              ),
              if (reviewId != null) ...[
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(16),
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: Colors.redAccent,
                    onPressed: deleteReview,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // --- HELPER METHODS ---

  Widget _buildCustomChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
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

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: inputColor,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        alignLabelWithHint: maxLines > 1,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? (maxLines * 10.0) : 0),
          child: Icon(icon, color: greenColor, size: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: greenColor, width: 1.5),
        ),
      ),
    );
  }
}
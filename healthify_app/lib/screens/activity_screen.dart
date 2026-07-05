import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/activity_log_model.dart';

class ActivityScreen extends StatefulWidget {
  final int userId;

  const ActivityScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color greenCard = const Color(0xFF114232);
  final Color limeGreen = const Color(0xFFC7F464);

  final durationController = TextEditingController();

  String selectedActivity = "Jalan kaki";
  String selectedIntensity = "ringan";

  int todayBurned = 0;

  List<ActivityLogModel> history = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });

    todayBurned =
        await ApiService.getTodayBurned(widget.userId);

    history =
        await ApiService.getActivityHistory(widget.userId);

    setState(() {
      isLoading = false;
    });
  }

  Future addActivity() async {

    if (durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Masukkan durasi aktivitas"),
        ),
      );
      return;
    }

    bool success = await ApiService.addActivity(
      widget.userId,
      selectedActivity,
      int.parse(durationController.text),
      selectedIntensity,
    );

    if (success) {

      durationController.clear();

      await loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aktivitas berhasil ditambahkan"),
        ),
      );
    }
  }

  IconData getActivityIcon(String activity) {
    switch (activity) {
      case "Jalan kaki":
        return Icons.directions_walk;

      case "Jogging":
        return Icons.directions_run;

      case "Bersepeda":
        return Icons.pedal_bike;

      case "Renang":
        return Icons.pool;
        
        case "Badminton":
  return Icons.sports_tennis;

      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          "Physical Activity",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: limeGreen,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  /// CARD KALORI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: greenCard,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [

                        const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFC7F464),
                          size: 50,
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Calories Burned Today",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "$todayBurned kcal",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// FORM
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Jenis Aktivitas",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          value: selectedActivity,
                          dropdownColor: cardColor,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black26,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          items: const [

                            DropdownMenuItem(
                              value: "Jalan kaki",
                              child: Text(
                                "🚶 Jalan kaki",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "Jogging",
                              child: Text(
                                "🏃 Jogging",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "Bersepeda",
                              child: Text(
                                "🚴 Bersepeda",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "Renang",
                              child: Text(
                                "🏊 Renang",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
  value: "Badminton",
  child: Text(
    "🏸 Badminton",
    style: TextStyle(color: Colors.white),
  ),
),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedActivity = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Durasi Aktivitas (menit)",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Contoh : 30",
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                            ),
                            filled: true,
                            fillColor: Colors.black26,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Intensitas Aktivitas",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          value: selectedIntensity,
                          dropdownColor: cardColor,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black26,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          items: const [

                            DropdownMenuItem(
                              value: "ringan",
                              child: Text(
                                "Ringan",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "sedang",
                              child: Text(
                                "Sedang",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "berat",
                              child: Text(
                                "Berat",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedIntensity = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: addActivity,
                            icon: const Icon(Icons.add),
                            label: const Text(
                              "Tambah Aktivitas",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: limeGreen,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Riwayat Aktivitas",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...history.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(

                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              limeGreen.withOpacity(.15),
                          child: Icon(
                            getActivityIcon(item.activityType),
                            color: limeGreen,
                          ),
                        ),

                        title: Text(
                          item.activityType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        subtitle: Text(
                          "${item.durationMinutes} menit • ${item.intensity}",
                          style: const TextStyle(
                            color: Colors.white60,
                          ),
                        ),

                        trailing: Text(
                          "${item.caloriesBurned} kcal",
                          style: TextStyle(
                            color: limeGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
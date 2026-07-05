import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/smart_reminder.dart';
import '../models/weekly_plan_model.dart'; 
import '../models/activity_log_model.dart';
import '../models/education_model.dart';// FIX: Ditambahkan agar kIsWeb tidak lagi 'Undefined name'
import '../models/food_ai_model.dart';


class ApiService {
  // GANTI: Menggunakan URL Ngrok aktifmu agar HP fisik bisa menembak database laptop lewat internet
  // KODE BARU (Sudah mengarah ke hosting live):
static const String baseUrl = 'https://api-healthify.tifpsdku.com/api';

  // Fungsi Ambil Top 3 Leaderboard Riil
  static Future<List<dynamic>> getLeaderboard(String limit) async {
    try {
      final response = await http.get(
        Uri.parse(
'$baseUrl/leaderboard/top?limit=$limit'
),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['leaderboard'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching leaderboard: $e");
      return [];
    }
  }

  // Fungsi Upload Foto Profil Hybrid
  static Future<String?> uploadProfilePicture(int userId, dynamic pickedFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/$userId/upload-profile-picture'),
      );

      if (kIsWeb) {
        var bytes = await pickedFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: pickedFile.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          pickedFile.path,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['profile_picture_url'];
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error upload API: $e"); // FIX: Menggunakan print biasa agar tidak memicu undefined_method
      return null;
    }
  }

  // Fungsi Register Asli
  static Future<Map<String, dynamic>> registerUser(
  String name,
  String email,
  String whatsappNumber,
  String password,
  Map<String, String> healthData,
) async {
    try {
      final Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'whatsapp_number': whatsappNumber,
        'password': password,
      };
      requestBody.addAll(healthData);

    final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message'] ?? 'Gagal mendaftar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // Fungsi Login Asli
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': email, 'password': password,}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)['user']};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan'};
    }
  }

  // Fungsi untuk mengambil daftar makanan dari database
  static Future<List<dynamic>> getFoods() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/foods'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['data'];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching foods: $e");
      return [];
    }
  }

  // Fungsi Simpan Jurnal
  static Future<bool> saveFoodLog(int userId, int foodId, double porsi, int totalKalori) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/food-logs'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'food_id': foodId,
          'porsi': porsi,
          'total_kalori': totalKalori,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Fungsi Ambil Data Hari Ini (FIX: Menyesuaikan route bawaan Laravelmu: /api/food-logs/today/{id})
  static Future<Map<String, dynamic>?> getTodayFoodLogs(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/food-logs/today/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching today food logs: $e");
      return null;
    }
  }

  static Future<Map<String,dynamic>?> getLatestScreening(
  int userId) async {

    try {

      final response = await http.get(
        Uri.parse('$baseUrl/screening/latest/$userId'),
      );

      if(response.statusCode==200){
        return jsonDecode(response.body);
      }

      return null;

    } catch(e){
      return null;
    }
  }

  static Future<List<dynamic>> getScreeningHistory(
  int userId) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/screening/history/$userId'
        ),
      );

      if(response.statusCode==200){

        return jsonDecode(response.body)['data'];

      }

      return [];

    } catch(e){

      return [];

    }
  }

    static Future<bool> updateProfile(
    int userId,
    String name,
    String email,
    String whatsapp,
  ) async {

    try {

      final response = await http.put(

        Uri.parse('$baseUrl/user/$userId'),

        headers: {
          'Content-Type':'application/json',
          'Accept':'application/json'
        },

        body: jsonEncode({

          'name': name,
          'email': email,
          'whatsapp_number': whatsapp,

        }),

      );

      return response.statusCode == 200;

    } catch(e) {

      return false;

    }

  }
  static Future<String> getObesityAlert(
  int userId) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/alerts/$userId',
        ),
      );

      if(response.statusCode==200){

        final data=jsonDecode(response.body);

        return data['alert_message'];

      }

    } catch (e) {
      // ignore error 
    }

    return "Pola makanmu sudah cukup baik.";
  }

  static Future<Map<String,dynamic>?> getDailyCoaching(
    int userId,
  ) async {

    final response = await http.get(
      Uri.parse('$baseUrl/coaching/daily/$userId'),
    );

    if(response.statusCode==200){

      final data = jsonDecode(response.body);

      return data['data'];
    }

    return null;
  }

  static Future<List<dynamic>> getCoachingHistory(
    int userId,
    ) async {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/coaching/history/$userId',
        ),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return data['data'];

      }

      return [];
    }
    static Future<Map<String, dynamic>?> getWeeklyReport(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weekly-report/$userId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      debugPrint("Error weekly report: $e");
      return null;
    }
    
  }
  Future<WeeklyPlanModel> getWeeklyPlan(int userId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/weekly-plan/$userId'),
  );

  final data = jsonDecode(response.body);

  return WeeklyPlanModel.fromJson(data['data']);
}
static Future<Map<String, dynamic>> sendCraving(
    int userId,
    String type,
) async {

  final response = await http.get(
    Uri.parse('$baseUrl/craving/$userId/$type'),
  );

  return jsonDecode(response.body);
}
static Future<Map<String, dynamic>> getStreak(
  int userId,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/streak/$userId',
      ),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    }

    return {};

  } catch (e) {

    return {};

  }

}
static Future<Map<String, dynamic>?> getMealSwap(
  int userId,
  String foodName,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/meal-swap/$userId/$foodName',
      ),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    }

    return null;

  } catch (e) {

    return null;

  }

}
static Future<Map<String, dynamic>?> getActivityRecommendation(
    int userId) async {

  try {

    final response = await http.get(
      Uri.parse('$baseUrl/activity-recommendation/$userId'),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      if (data['success']) {
        return data['data'];
      }
    }

  } catch (e) {
    print(e);
  }

  return null;
}
static Future<List<dynamic>> getFoodHistory(
  int userId,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/food-logs/history/$userId',
      ),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data['data'];

    }

    return [];

  } catch (e) {

    return [];

  }
}
static Future<bool> addActivity(
  int userId,
  String activityType,
  int durationMinutes,
  String intensity,
) async {

  try {

    final response = await http.post(
      Uri.parse('$baseUrl/activity-log'),
      headers: {
        'Content-Type':'application/json',
        'Accept':'application/json'
      },
      body: jsonEncode({
        'user_id': userId,
        'activity_type': activityType,
        'duration_minutes': durationMinutes,
        'intensity': intensity
      }),
    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }
}
static Future<List<ActivityLogModel>>
getActivityHistory(int userId) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/activity-log/history/$userId',
      ),
    );

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      return data
          .map((e) => ActivityLogModel.fromJson(e))
          .toList();
    }

    return [];

  } catch (e) {

    return [];

  }
}
static Future<int> getTodayBurned(
  int userId,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/activity-log/today-burned/$userId',
      ),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return int.parse(
        data['today_burned'].toString(),
      );

    }

    return 0;

  } catch (e) {

    return 0;

  }
}
static Future<List<EducationModel>> getEducations() async {

  final response = await http.get(
    Uri.parse('$baseUrl/education'),
  );

  if (response.statusCode == 200) {

    final List data = jsonDecode(response.body);

    return data
        .map((e) => EducationModel.fromJson(e))
        .toList();
  }

  return [];
}
static Future<bool> deleteAccount(
  int userId,
) async {

  try {

    final response = await http.delete(

      Uri.parse(
        '$baseUrl/delete-account/$userId',
      ),

    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }
}
static Future<Map<String, dynamic>?> getWeightLossPlan(
    int userId) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/weight-loss-plan/$userId',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;

  } catch (e) {

    return null;

  }
}
static Future<Map<String, dynamic>?> getMedicalSafety(
    int userId) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/medical-safety/$userId',
      ),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    }

    return null;

  } catch (e) {

    return null;

  }

}// ==========================================
// SMART REMINDER
// ==========================================

static Future<List<SmartReminder>> getSmartReminders(
    int userId,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/smart-reminders/$userId',
      ),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final List reminders = data['data'];

      return reminders
          .map(
            (e) => SmartReminder.fromJson(e),
          )
          .toList();

    }

    return [];

  } catch (e) {

    debugPrint(
      "Smart Reminder Error : $e",
    );

    return [];

  }

}
static Future<bool> completeReminder(
    int reminderId,
) async {

  try {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/smart-reminders/complete/$reminderId',
      ),
    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }

}
static Future<bool> regenerateReminder(
    int userId,
) async {

  try {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/smart-reminders/regenerate/$userId',
      ),
    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }

}
static Future<bool> deleteTodayReminder(
    int userId,
) async {

  try {

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/smart-reminders/$userId',
      ),
    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }

}
// ==========================================
// AI FOOD PARSING
// ==========================================

static Future<FoodAIResponse?> parseFoodAI(
  int userId,
  String text,
) async {

  try {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/food-parsing',
      ),

      headers: {

        'Content-Type':'application/json',
        'Accept':'application/json',

      },

      body: jsonEncode({

        'user_id': userId,

        'text': text,

      }),

    );

    if(response.statusCode==200){

      final data=jsonDecode(response.body);

      return FoodAIResponse.fromJson(data);

    }

    return null;

  } catch(e){

    debugPrint(
      'Food AI Error : $e',
    );

    return null;

  }

}
// ==========================================
// EXPERT REVIEW
// ==========================================

static Future<Map<String, dynamic>?> getExpertReview(
    int userId,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/expert-reviews/$userId',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;

  } catch (e) {

    debugPrint(
      'Expert Review Error : $e',
    );

    return null;

  }

}
static Future<bool> createExpertReview({

  required int userId,
  required String expertName,
  required String expertNote,
  required String mealPlan,
  required String status,

}) async {

  try {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/expert-reviews',
      ),

      headers: {

        'Content-Type':'application/json',
        'Accept':'application/json',

      },

      body: jsonEncode({

        'user_id': userId,
        'expert_name': expertName,
        'expert_note': expertNote,
        'meal_plan': mealPlan,
        'status': status,

      }),

    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }

}
static Future<bool> updateExpertReview({

  required int reviewId,
  required String expertName,
  required String expertNote,
  required String mealPlan,
  required String status,

}) async {

  try {

    final response = await http.put(

      Uri.parse(
        '$baseUrl/expert-reviews/$reviewId',
      ),

      headers: {

        'Content-Type':'application/json',
        'Accept':'application/json',

      },

      body: jsonEncode({

        'expert_name': expertName,
        'expert_note': expertNote,
        'meal_plan': mealPlan,
        'status': status,

      }),

    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }

}
static Future<bool> deleteExpertReview(
    int reviewId,
) async {

  try {

    final response = await http.delete(

      Uri.parse(
        '$baseUrl/expert-reviews/$reviewId',
      ),

    );

    return response.statusCode == 200;

  } catch (e) {

    return false;

  }

}
static Future<List<dynamic>> getExpertUsers() async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/expert/users"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["data"];
    }

    return [];
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
static Future<Map<String, dynamic>?> getUserExpertReview(
    int userId,
) async {

  final response = await http.get(
    Uri.parse("$baseUrl/user/expert-review/$userId"),
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    return data["data"];

  }

  return null;
}
    }
    
class ActivityLogModel {
  final int id;
  final int userId;
  final String activityType;
  final int durationMinutes;
  final String intensity;
  final int caloriesBurned;

  ActivityLogModel({
    required this.id,
    required this.userId,
    required this.activityType,
    required this.durationMinutes,
    required this.intensity,
    required this.caloriesBurned,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'],
      userId: json['user_id'],
      activityType: json['activity_type'],
      durationMinutes: json['duration_minutes'],
      intensity: json['intensity'],
      caloriesBurned: json['calories_burned'],
    );
  }
}
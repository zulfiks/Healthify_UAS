class SmartReminder {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String reminderTime;
  final String reminderType;
  final bool isCompleted;
  final String generatedForDate;

  SmartReminder({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.reminderTime,
    required this.reminderType,
    required this.isCompleted,
    required this.generatedForDate,
  });

  factory SmartReminder.fromJson(Map<String, dynamic> json) {
    return SmartReminder(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      reminderTime: json['reminder_time'] ?? '',
      reminderType: json['reminder_type'] ?? '',
      isCompleted: json['is_completed'] == true ||
          json['is_completed'].toString() == '1',
      generatedForDate: json['generated_for_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'reminder_time': reminderTime,
      'reminder_type': reminderType,
      'is_completed': isCompleted,
      'generated_for_date': generatedForDate,
    };
  }

  String get iconEmoji {
    switch (reminderType) {
      case 'meal':
        return '🍽️';

      case 'water':
        return '💧';

      case 'exercise':
        return '🏃';

      case 'sleep':
        return '😴';

      case 'motivation':
        return '💪';

      default:
        return '🔔';
    }
  }
}
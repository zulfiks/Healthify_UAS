class WeeklyPlanModel {
  final String focus;
  final String activityTarget;
  final String smallHabit;
  final String menuRecommendation;

  WeeklyPlanModel({
    required this.focus,
    required this.activityTarget,
    required this.smallHabit,
    required this.menuRecommendation,
  });

  factory WeeklyPlanModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanModel(
      focus: json['focus'] ?? '',
      activityTarget: json['activity_target'] ?? '',
      smallHabit: json['small_habit'] ?? '',
      menuRecommendation: json['menu_recommendation'] ?? '',
    );
  }
}
class EducationModel {

  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final String category;
  final String url;

  EducationModel({

    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.category,
    required this.url,

  });

  factory EducationModel.fromJson(
      Map<String,dynamic> json){

    return EducationModel(

      id: json['id'],

      title: json['title'],

      description: json['description'] ?? '',

      imageUrl: json['image_url'] ?? '',

      type: json['type'],

      category: json['category'] ?? '',

      url: json['url'] ?? '',

    );
  }
}
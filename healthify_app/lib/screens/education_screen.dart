import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/education_model.dart';
import '../services/api_service.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final Color bgColor = Colors.black;
  final Color cardColor = const Color(0xFF161616);
  final Color limeGreen = const Color(0xFFC7F464);

  String selectedFilter = "all";

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget buildFilterChip(
    String title,
    String value,
  ) {
    bool selected = selectedFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? limeGreen : cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildCard(EducationModel item) {
    IconData icon;
    Color iconColor;

    switch (item.type) {
      case "youtube":
        icon = Icons.play_circle_fill;
        iconColor = Colors.red;
        break;

      case "tiktok":
        icon = Icons.music_note;
        iconColor = Colors.cyanAccent;
        break;

      default:
        icon = Icons.article;
        iconColor = limeGreen;
    }

    return GestureDetector(
      onTap: () {
        if (item.url.isNotEmpty) {
          openLink(item.url);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Icon(
                          icon,
                          size: 16,
                          color: iconColor,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            item.category,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: limeGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        title: const Text(
          "Konten Edukasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<EducationModel>>(

        future: ApiService.getEducations(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return Center(
              child: CircularProgressIndicator(
                color: limeGreen,
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {

            return const Center(
              child: Text(
                "Belum ada konten edukasi",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final educations = snapshot.data!;

          List<EducationModel> filtered = educations;

          if (selectedFilter != "all") {

            filtered = educations
                .where(
                  (e) => e.type == selectedFilter,
                )
                .toList();

          }

          return Padding(
            padding: const EdgeInsets.all(15),

            child: Column(

              children: [

                SizedBox(
                  height: 45,

                  child: ListView(
                    scrollDirection: Axis.horizontal,

                    children: [

                      buildFilterChip(
                        "Semua",
                        "all",
                      ),

                      const SizedBox(width: 10),

                      buildFilterChip(
                        "Artikel",
                        "article",
                      ),

                      const SizedBox(width: 10),

                      buildFilterChip(
                        "Youtube",
                        "youtube",
                      ),

                      const SizedBox(width: 10),

                      buildFilterChip(
                        "TikTok",
                        "tiktok",
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: GridView.builder(

                    itemCount: filtered.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 2,

                      crossAxisSpacing: 15,

                      mainAxisSpacing: 15,

                      childAspectRatio: 0.72,

                    ),

                    itemBuilder: (context, index) {

                      return buildCard(
                        filtered[index],
                      );

                    },

                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
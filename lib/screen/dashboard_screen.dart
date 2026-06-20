import 'package:flutter/material.dart';
import 'package:ganesha_app/screen/story_cateogry/StoryCategoriesScreen.dart';
import 'package:ganesha_app/screen/Aarti_Screen/AartiScreen.dart';
import 'package:ganesha_app/screen/akshar_ganpati/AksharGanpatiScreen.dart';
import 'package:ganesha_app/screen/decoration_screen/DecorationScreen.dart';
import 'package:ganesha_app/screen/famous_pandals/famous_pandals_screen.dart';
import 'package:ganesha_app/screen/ganesh_images/GaneshImages_Screen.dart';
import 'package:ganesha_app/screen/murtikar/MurtikarScreen.dart';
import 'package:ganesha_app/screen/stories/stories_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Grid item configurations
    final List<Map<String, dynamic>> menuItems = [
      {"title": "Ganesha Images", "icon": Icons.image},
      {"title": "Famous Pandals", "icon": Icons.fort},
      {"title": "Murtikar", "icon": Icons.handyman},
      {"title": "Decoration Ideas", "icon": Icons.lightbulb},
      {"title": "Aarti", "icon": Icons.music_note},
      {"title": "Stories", "icon": Icons.auto_stories},
      {"title": "Akshar Ganpati", "icon": Icons.font_download},
      {"title": "Story Categories", "icon": Icons.category},
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text(
          "My Ganesha",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Proportional & Responsive Banner Header
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      
                      aspectRatio: 16 / 9, 
                      child: Image.asset(
                        'assets/ganesha.jpg',
                        width: double.infinity,
                        fit: BoxFit.fitWidth, 
                        // Center keeps the focal point exact. Switch to Alignment.topCenter if needed
                        alignment: Alignment.center, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "॥ गणेशाय नमः ॥",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Menu Items Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = menuItems[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GaneshImagesScreen(),
                            ),
                          );
                          break;
                        case 1:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FamousPandalsScreen(),
                            ),
                          );
                          break;
                        case 2:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MurtikarScreen(),
                            ),
                          );
                          break;
                        case 3:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DecorationScreen(),
                            ),
                          );
                          break;
                        case 4:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AartiScreen(),
                            ),
                          );
                          break;
                        case 5:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StoriesScreen(),
                            ),
                          );
                          break;
                        case 6:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AksharGanpatiScreen(),
                            ),
                          );
                          break;
                        case 7:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StoryCategoryScreen(),
                            ),
                          );
                          break;
                      }
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.orange.withOpacity(.15),
                            child: Icon(
                              item["icon"],
                              size: 30,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              item["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: menuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
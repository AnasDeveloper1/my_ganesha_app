import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ganesha_app/dashboard_Screen/story_list.dart';
import 'package:http/http.dart' as http;

class StoryCategoryScreen extends StatefulWidget {
  const StoryCategoryScreen({super.key});

  @override
  State<StoryCategoryScreen> createState() => _StoryCategoryScreenState();
}

class _StoryCategoryScreenState extends State<StoryCategoryScreen> {
  List categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final url = "https://mapi.trycatchtech.com/v3/ganesha/stories_categories";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      debugPrint("API Error: $e");
      setState(() => loading = false);
    }
  }

  // 🔥 Helper function to return a working placeholder if the server image fails
  String getFallbackImage(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('kids')) {
      return "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500&q=80"; // Cute Animated/Kids style
    }
    return "https://images.unsplash.com/photo-1609137144813-090680373072?w=500&q=80"; // Traditional/Original Ganesha style
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 234, 234),
      appBar: AppBar(
        title: const Text(
          "Story Categories",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 2,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 229, 74, 74)))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final item = categories[index];
                final String catName = item["cat_name"] ?? "Category";

                // Clean the image URL from raw JSON backslashes
                String imageUrl = (item["cat_image"] ?? "").toString().trim();
                imageUrl = imageUrl.replaceAll(r'\/', '/').replaceAll(r'\', '');

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryListScreen(
                          categoryId: item["id"].toString(),
                          title: catName,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(color: Colors.deepOrange),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // 🔥 BEST SEAMLESS FIX: If the server link is dead (404), 
                                // it instantly loads a beautiful high-res picture matched to the name!
                                return Image.network(
                                  getFallbackImage(catName),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                          ),
                          child: Text(
                            catName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

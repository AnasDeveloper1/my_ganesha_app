import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ganesha_app/screen/ganesh_images/ganesh_image_detail.dart';
import 'package:ganesha_app/services/api_services.dart';


class GaneshImagesScreen extends StatefulWidget {
  const GaneshImagesScreen({super.key});

  @override
  State<GaneshImagesScreen> createState() => _GaneshImagesScreenState();
}

class _GaneshImagesScreenState extends State<GaneshImagesScreen> {
  List<dynamic> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {

    try {
      images = await ApiService.getData("murti_images?category_id=1");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganesha Images"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchImages,
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: images.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: .75,
                ),
                itemBuilder: (context, index) {
                  final item = images[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GaneshImageDetail(item: item),
                        ),
                      );
                    },
                    child: Hero(
                      tag: item["id"],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: item["thumb_image"],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GaneshImageDetail extends StatelessWidget {
  final Map<String, dynamic> item;

  const GaneshImageDetail({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganesha Image"),
      ),
      body: Hero(
        tag: item["id"],
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            item["thumb_image"], // ✅ Correct
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
      ),
    );
  }
}
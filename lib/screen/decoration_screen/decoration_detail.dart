import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DecorationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const DecorationDetailScreen({super.key, required this.item});

  String safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? "Not Available" : v.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Decoration Idea"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: safe(item["image"]),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 80),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                safe(item["description"]),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
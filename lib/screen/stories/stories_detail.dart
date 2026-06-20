import 'package:flutter/material.dart';

class StoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const StoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item["title"] ?? "Story"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item["image"] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item["image"],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),

            Text(
              item["title"] ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              item["description"] ?? "",
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
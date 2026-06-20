import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MurtikarDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const MurtikarDetailScreen({super.key, required this.item});

  String safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? "Not Available" : v.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(safe(item["name"]))),
      body: SingleChildScrollView(
        child: Column(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    safe(item["name"]),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ListTile(
                    leading:
                        const Icon(Icons.phone, color: Colors.green),
                    title: const Text("Contact"),
                    subtitle: Text(safe(item["contact"])),
                  ),

                  ListTile(
                    leading:
                        const Icon(Icons.location_on, color: Colors.red),
                    title: const Text("Location"),
                    subtitle: Text(safe(item["location"])),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
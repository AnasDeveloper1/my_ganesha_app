import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ganesha_app/services/api_services.dart';

import 'murtikar_detail.dart';

class MurtikarScreen extends StatefulWidget {
  const MurtikarScreen({super.key});

  @override
  State<MurtikarScreen> createState() => _MurtikarScreenState();
}

class _MurtikarScreenState extends State<MurtikarScreen> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();

    // ✅ CORRECT ENDPOINT
    futureData = ApiService.getData("murtikar?category_id=3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Murtikar"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: item["thumb_image"] ?? "",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.image),
                  ),
                  title: Text(item["name"] ?? "No Name"),
                  subtitle: Text(item["contact"] ?? "Not Available"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MurtikarDetailScreen(item: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
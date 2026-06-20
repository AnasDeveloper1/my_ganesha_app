import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ganesha_app/services/api_services.dart';

import 'decoration_detail.dart';

class DecorationScreen extends StatefulWidget {
  const DecorationScreen({super.key});

  @override
  State<DecorationScreen> createState() => _DecorationScreenState();
}

class _DecorationScreenState extends State<DecorationScreen> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();

    futureData = ApiService.getData("decoration_ideas");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Decoration Ideas"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: item["thumb_image"] ?? "",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.image),
                  ),
                  title: Text("Decoration Idea ${item["id"]}"),
                  subtitle: Text(
                    (item["description"] ?? "")
                        .toString()
                        .split("\r\n")
                        .first,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DecorationDetailScreen(item: item),
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
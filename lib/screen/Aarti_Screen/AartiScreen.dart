import 'package:flutter/material.dart';
import 'package:ganesha_app/services/api_services.dart';

import 'aarti_detail.dart';

class AartiScreen extends StatefulWidget {
  const AartiScreen({super.key});

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = ApiService.getData("aarti");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aarti"),
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

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(item["title"] ?? "No Title"),
                  subtitle: Text(
                    (item["description"] ?? "")
                        .toString()
                        .split("\n")
                        .first,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AartiDetailScreen(item: item),
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
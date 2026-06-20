import 'package:flutter/material.dart';
import 'package:ganesha_app/services/api_services.dart';

class AksharGanpatiScreen extends StatefulWidget {
  const AksharGanpatiScreen({super.key});

  @override
  State<AksharGanpatiScreen> createState() => _AksharGanpatiScreenState();
}

class _AksharGanpatiScreenState extends State<AksharGanpatiScreen> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = ApiService.getData("akshar_ganpati");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akshar Ganpati")),
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

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Image.network(item["image"]),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          item["thumb_image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(item["name"] ?? ""),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
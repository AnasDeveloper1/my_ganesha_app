import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ganesha_app/screen/famous_pandals/famous_pandal_detail.dart';

import 'package:ganesha_app/services/api_services.dart';

class FamousPandalsScreen extends StatefulWidget {
  const FamousPandalsScreen({super.key});

  @override
  State<FamousPandalsScreen> createState() => _FamousPandalsScreenState();
}

class _FamousPandalsScreenState extends State<FamousPandalsScreen> {
  List<dynamic> pandals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPandals();
  }

  Future<void> fetchPandals() async {
    try {
      pandals = await ApiService.getData("famous_pandals");
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
        title: const Text("Famous Pandals"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pandals.length,
              itemBuilder: (context, index) {
                final item = pandals[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Hero(
                      tag: item["id"],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item["thumb_image"],
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(item["title"] ?? ""),
                    subtitle: Text(item["location"] ?? ""),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FamousPandalDetail(item: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
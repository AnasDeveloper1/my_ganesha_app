import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoryListScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const StoryListScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  List stories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  Future<void> fetchStories() async {
    final url =
        "https://mapi.trycatchtech.com/v3/ganesha/stories?category_id=${widget.categoryId}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        stories = json.decode(response.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : stories.isEmpty
              ? const Center(child: Text("No stories found"))
              : ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final item = stories[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.network(
                          item["image"] ?? "",
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image),
                        ),
                        title: Text(item["title"] ?? ""),
                      ),
                    );
                  },
                ),
    );
  }
}
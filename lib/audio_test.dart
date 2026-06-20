import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AartiDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const AartiDetailScreen({super.key, required this.item});

  @override
  State<AartiDetailScreen> createState() => _AartiDetailScreenState();
}

class _AartiDetailScreenState extends State<AartiDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initSession();
  }

  Future<void> initSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> toggle() async {
    final url = widget.item["audio"];

    try {
      if (isPlaying) {
        await _player.pause();
        setState(() => isPlaying = false);
        return;
      }

      await _player.setUrl(url);
      await _player.play();

      setState(() => isPlaying = true);
    } catch (e) {
      print("AUDIO ERROR: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item["title"] ?? "Aarti")),
      body: Center(
        child: ElevatedButton(
          onPressed: toggle,
          child: Text(isPlaying ? "Pause" : "Play"),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';

class AartiDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const AartiDetailScreen({super.key, required this.item});

  @override
  State<AartiDetailScreen> createState() => _AartiDetailScreenState();
}

class _AartiDetailScreenState extends State<AartiDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlayerInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAudioSession();
    _prepareAudio();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    
    _player.playerStateStream.listen((state) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _prepareAudio() async {
    String url = widget.item["audio"] ?? "";
    
    if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "https://");
    }
    if (url.isEmpty) return;

    try {
      setState(() => _isLoading = true);
      await _player.setUrl(url);
      _isPlayerInitialized = true;
    } catch (e) {
      print("AUDIO INIT ERROR: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<void> toggle() async {
    if (!_isPlayerInitialized && !_isLoading) {
      await _prepareAudio();
    }

    try {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      print("PLAYBACK ERROR: $e");
    }
  }

  void seekForward() {
    final currentPosition = _player.position;
    final totalDuration = _player.duration ?? Duration.zero;
    final newPosition = currentPosition + const Duration(seconds: 10);
    
    if (newPosition < totalDuration) {
      _player.seek(newPosition);
    } else {
      _player.seek(totalDuration);
    }
  }

  void seekBackward() {
    final currentPosition = _player.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    
    if (newPosition > Duration.zero) {
      _player.seek(newPosition);
    } else {
      _player.seek(Duration.zero);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _player.playing;
    final title = widget.item["title"] ?? "Aarti Detail";
    final description = widget.item["description"] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Title Block
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Audio Control Panel (Upward - where it originally was)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.replay_10),
                    onPressed: _isLoading ? null : seekBackward,
                  ),
                  const SizedBox(width: 12),
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          iconSize: 64,
                          color: Theme.of(context).colorScheme.primary,
                          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                          onPressed: toggle,
                        ),
                  const SizedBox(width: 12),
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.forward_10),
                    onPressed: _isLoading ? null : seekForward,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Progress Slider Bar (Right beneath the control capsule)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data ??
                      PositionData(Duration.zero, Duration.zero, Duration.zero);
                  return ProgressBar(
                    progress: positionData.position,
                    buffered: positionData.bufferedPosition,
                    total: positionData.duration,
                    onSeek: _player.seek,
                    progressBarColor: Theme.of(context).colorScheme.primary,
                    baseBarColor: Colors.grey.withOpacity(0.2),
                    bufferedBarColor: Colors.grey.withOpacity(0.35),
                    thumbColor: Theme.of(context).colorScheme.primary,
                    timeLabelTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // 4. Full Scrollable Lyrics Output
            if (description.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.library_books, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Lyrics & Verses",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 20),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  letterSpacing: 0.3,
                ),
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  "No lyrics available for this Aarti.",
                  style: TextStyle(color: Colors.grey,),
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
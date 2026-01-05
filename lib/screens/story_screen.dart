import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/tts_service.dart';
import '../widgets/waveform.dart';

class StoryScreen extends StatefulWidget {
  final Story story;

  const StoryScreen({super.key, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final TtsService _ttsService = TtsService();
  int currentIndex = 0;
  bool isPlaying = false;

  List<String> get segments => widget.story.segments;

  @override
  void initState() {
    super.initState();
    _ttsService.init(
      onComplete: _onSegmentCompleted,
    );
  }

  Future<void> play() async {
    setState(() => isPlaying = true);
    await _ttsService.speak(segments[currentIndex]);
  }

  Future<void> pause() async {
    await _ttsService.stop();
    setState(() => isPlaying = false);
  }

  void restart() {
    pause();
    setState(() => currentIndex = 0);
  }

  void nextSegment() {
    if (currentIndex < segments.length - 1) {
      setState(() => currentIndex++);
      play();
    } else {
      pause();
    }
  }

  void _onSegmentCompleted() {
    if (currentIndex < segments.length - 1) {
      setState(() => currentIndex++);
      play();
    } else {
      setState(() => isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// 🎧 Fancy waveform
            Expanded(
              child: Center(
                child: Waveform(isPlaying: isPlaying),
              ),
            ),

            /// 🔘 Segment progress (PARTS, not time)
            Slider(
              value: currentIndex.toDouble(),
              min: 0,
              max: (segments.length - 1).toDouble(),
              divisions: segments.length - 1,
              label: "Part ${currentIndex + 1}",
              onChanged: isPlaying
                  ? null
                  : (value) {
                setState(() => currentIndex = value.toInt());
                play();
              },
            ),

            /// ▶️ Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: isPlaying ? pause : play,
                ),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.restart_alt),
                  onPressed: restart,
                ),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next),
                  onPressed: nextSegment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

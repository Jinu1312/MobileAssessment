import 'package:flutter/material.dart';
import '../data/story_data.dart';
import '../services/tts_service.dart';
import '../widgets/waveform.dart';


class StoryScreen extends StatefulWidget {
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final TtsService _ttsService = TtsService();
  int currentIndex = 0;
  bool isPlaying = false;

  void play() async {
    setState(() => isPlaying = true);
    await _ttsService.speak(storySegments[currentIndex].text);
  }

  void pause() async {
    setState(() => isPlaying = false);
    await _ttsService.stop();
  }

  void restart() {
    setState(() {
      currentIndex = 0;
      isPlaying = false;
    });
  }

  void nextSegment() {
    if (currentIndex < storySegments.length - 1) {
      setState(() => currentIndex++);
      play();
    } else {
      pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final segment = storySegments[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Interview Story Portal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "The Mystery of the Disappearing Product Link",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Center(
                child: Waveform(isPlaying: isPlaying),
              ),
            ),

            Slider(
              value: currentIndex.toDouble(),
              min: 0,
              max: (storySegments.length - 1).toDouble(),
              divisions: storySegments.length - 1,
              label: "Part ${currentIndex + 1}",
              onChanged: isPlaying
                  ? null // 🔒 disable seek while speaking
                  : (value) {
                setState(() {
                  currentIndex = value.toInt();
                });
                play();
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: isPlaying ? pause : play,
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.restart_alt),
                  onPressed: restart,
                ),
                IconButton(
                  iconSize: 36,
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

  @override
  void initState() {
    super.initState();
    _ttsService.init();

    _ttsService.onComplete = () {
      if (!mounted) return;

      if (currentIndex < storySegments.length - 1) {
        setState(() {
          currentIndex++;
        });
        play();
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    };
  }


}

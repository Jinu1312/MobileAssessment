import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/tts_service.dart';
import '../widgets/waveform.dart';
import 'question_screen.dart';

class StoryListeningScreen extends StatefulWidget {
  final Story story;

  const StoryListeningScreen({super.key, required this.story});

  @override
  State<StoryListeningScreen> createState() => _StoryListeningScreenState();
}

class _StoryListeningScreenState extends State<StoryListeningScreen> {
  final TtsService _ttsService = TtsService();
  int currentSegmentIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _ttsService.onComplete = _onSegmentComplete;
  }

  void _playCurrentSegment() {
    setState(() => isPlaying = true);
    _ttsService.speak(widget.story.segments[currentSegmentIndex]);
  }

  void _onSegmentComplete() {
    if (currentSegmentIndex < widget.story.segments.length - 1) {
      setState(() => currentSegmentIndex++);
      _playCurrentSegment();
    } else {
      setState(() => isPlaying = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionScreen(story: widget.story),
        ),
      );
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Waveform(isPlaying: isPlaying),
          const SizedBox(height: 20),
          Slider(
            value: currentSegmentIndex.toDouble(),
            min: 0,
            max: (widget.story.segments.length - 1).toDouble(),
            divisions: widget.story.segments.length - 1,
            label: "Part ${currentSegmentIndex + 1}",
            onChanged: isPlaying
                ? null // 🔒 disable seek while audio is playing
                : (value) {
              setState(() {
                currentSegmentIndex = value.toInt();
              });
              _playCurrentSegment(); // Play selected segment manually
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isPlaying ? null : () {
                  _playCurrentSegment();
                },
                child: const Text("Play"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: isPlaying
                      ? () {
                          _ttsService.stop();
                          setState(() => isPlaying = false);
                        }
                      : null,
                  child: const Text("Pause")),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () {
                    _ttsService.stop();
                    setState(() {
                      currentSegmentIndex = 0;
                    });
                    _playCurrentSegment();
                  },
                  child: const Text("Restart")),
            ],
          )
        ],
      ),
    );
  }
}

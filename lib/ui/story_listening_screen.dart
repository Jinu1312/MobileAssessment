import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/story_result.dart';
import '../services/tts_service.dart';
import '../widgets/animated_waveform.dart';
import '../widgets/play_button.dart';
import '../data/stories.dart'; // <-- your provided stories list
import 'question_screen.dart';

class StoryListeningScreen extends StatefulWidget {
  final int storyIndex;
  final List<StoryResult> results;

  const StoryListeningScreen({
    super.key,
    required this.storyIndex,
    required this.results,
  });

  @override
  State<StoryListeningScreen> createState() => _StoryListeningScreenState();
}

class _StoryListeningScreenState extends State<StoryListeningScreen> {
  late final TtsService _tts;
  late final Story story;

  bool isPlaying = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    story = stories[widget.storyIndex];

    _tts = TtsService();
    _tts.init(onComplete: _onSegmentCompleted);
  }

  Future<void> _togglePlay() async {
    if (isPlaying) {
      await _tts.stop();
      setState(() => isPlaying = false);
    } else {
      setState(() => isPlaying = true);
      await _tts.speak(story.segments[currentIndex]);
    }
  }

  void _onSegmentCompleted() {
    if (!mounted) return;

    if (currentIndex < story.segments.length - 1) {
      setState(() => currentIndex++);
      _tts.speak(story.segments[currentIndex]);
    } else {
      setState(() => isPlaying = false);
    }
  }

  void _goToQuestions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionScreen(story: story,results: widget.results,),
      ),
    );
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastSegment = currentIndex == story.segments.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Scenario ${widget.storyIndex + 1}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                story.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Center(
                child: AnimatedWaveform(isPlaying: isPlaying),
              ),

              const SizedBox(height: 32),

              Slider(
                value: currentIndex.toDouble(),
                min: 0,
                max: (story.segments.length - 1).toDouble(),
                divisions: story.segments.length - 1,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.white24,
                label: "Part ${currentIndex + 1}",
                onChanged: (value) {
                  if (!isPlaying) {
                    setState(() {
                      currentIndex = value.toInt();
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              // Play button stays as is
              Center(
                child: PlayButton(
                  isPlaying: isPlaying,
                  onTap: _togglePlay,
                ),
              ),

              const SizedBox(height: 16),

              // Only show "Answer Questions" button if last segment is reached
              if (isLastSegment)
                Center(
                  child: ElevatedButton(
                    onPressed: _goToQuestions,
                    child: const Text("Go to Questions"),
                  ),
                ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  story.segments.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == currentIndex
                          ? Colors.blueAccent
                          : Colors.white24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
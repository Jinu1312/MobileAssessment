import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/story_result.dart';
import '../services/tts_service.dart';
import '../widgets/animated_waveform.dart';
import '../widgets/play_button.dart';
import '../data/stories.dart';
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
        builder: (_) => QuestionScreen(
          story: story,
          results: widget.results,
        ),
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
    final int partCount = story.segments.length;

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
              const SizedBox(height: 24),

              /// MAIN CONTENT
              Expanded(
                child: Column(
                  children: [
                    /// TOP AREA (slider + buttons)
                    Expanded(
                      child: Row(
                        children: [
                          /// LEFT – PARTS + SLIDER (shared layout math)
                          SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                /// PART LABELS (aligned by Expanded rows)
                                Column(
                                  children: List.generate(partCount, (i) {
                                    final index = partCount - 1 - i;
                                    final isActive = currentIndex == index;

                                    return Expanded(
                                      child: Row(
                                        children: [
                                          /// PART LABEL
                                          AnimatedDefaultTextStyle(
                                            duration: const Duration(milliseconds: 300),
                                            style: TextStyle(
                                              fontSize: isActive ? 13 : 12,
                                              fontWeight:
                                              isActive ? FontWeight.w600 : FontWeight.normal,
                                              color: isActive
                                                  ? Colors.blueAccent
                                                  : Colors.white70,
                                            ),
                                            child: Text("Part ${index + 1}"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),


                                const SizedBox(width: 6),

                                /// VERTICAL SLIDER (same Expanded height)
                                Expanded(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 4,
                                        overlayShape:
                                        SliderComponentShape.noOverlay,
                                        thumbShape:
                                        const RoundSliderThumbShape(
                                          enabledThumbRadius: 8,
                                        ),
                                      ),
                                      child: Slider(
                                        value: currentIndex.toDouble(),
                                        min: 0,
                                        max: (partCount - 1).toDouble(),
                                        divisions:
                                        partCount > 1 ? partCount - 1 : 1,
                                        activeColor: Colors.blueAccent,
                                        inactiveColor: Colors.white24,
                                        onChanged: (value) {
                                          if (!isPlaying) {
                                            setState(() {
                                              currentIndex = value.toInt();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 24),

                          /// RIGHT – CENTER BUTTONS
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedScale(
                                  scale: isPlaying ? 1.0 : 1.08,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                  child: PlayButton(
                                    isPlaying: isPlaying,
                                    onTap: _togglePlay,
                                  ),
                                ),

                                const SizedBox(height: 16),
                                if (isLastSegment)
                                  ElevatedButton(
                                    onPressed: _goToQuestions,
                                    child: const Text("Go to Questions"),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// BOTTOM – WAVEFORM + DOTS
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          AnimatedWaveform(isPlaying: isPlaying),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

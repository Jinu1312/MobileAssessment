import 'package:flutter/material.dart';
import 'package:mobile_assessment/ui/story_listening_screen.dart';
import '../models/story.dart';
import '../models/question.dart';
import '../models/story_result.dart';
import '../data/stories.dart';
import 'package:flutter/material.dart';
import '../models/story_result.dart'; // create this model
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuestionScreen extends StatefulWidget {
  final Story story;
  final List<StoryResult> results; // pass from previous screen or empty list

  const QuestionScreen({
    super.key,
    required this.story,
    required this.results,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final Map<String, Set<int>> answers = {};
  int currentQuestionIndex = 0;

  bool get allAnswered =>
      widget.story.questions.every((q) => answers[q.id]?.isNotEmpty == true);

  // Calculate correct answers for the current story
  int calculateCorrectAnswers(Story story, Map<String, Set<int>> answers) {
    int correctCount = 0;

    for (var question in story.questions) {
      final userAnswer = answers[question.id] ?? {};

      if (question.type == QuestionType.singleChoice) {
        // Single choice: one correct answer
        if (userAnswer.length == 1 && userAnswer.first == question.correctAnswers.first) {
          correctCount++;
        }
      } else {
        // Multi-choice: all correct selected, no extra
        if (userAnswer.length == question.correctAnswers.length &&
            userAnswer.every((a) => question.correctAnswers.contains(a))) {
          correctCount++;
        }
      }
    }

    return correctCount;
  }


  void goToNext() {
    final currentIndexInStories =
    stories.indexWhere((s) => s.id == widget.story.id);

    // Store score for current story
    int score = calculateCorrectAnswers(widget.story, answers);
    widget.results.add(
      StoryResult(
        storyId: widget.story.id,
        storyTitle: widget.story.title,
        correctAnswers: score,
        totalQuestions: widget.story.questions.length,
      ),
    );

    if (currentIndexInStories < stories.length - 1) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StoryListeningScreen(
            storyIndex: currentIndexInStories + 1,
            results: widget.results,
          ),
        ),
      );

    } else {
      // Last story → Go to completion screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => CompletionScreen(results: widget.results),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final question = widget.story.questions[currentQuestionIndex];
    final selected = answers[question.id] ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / widget.story.questions.length,
                backgroundColor: Colors.white24,
                color: Colors.blueAccent,
                minHeight: 6,
              ),
              const SizedBox(height: 24),

              // Question text
              Text(
                question.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Options
              ...List.generate(
                question.options.length,
                    (index) {
                  final isSelected = selected.contains(index);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            if (question.type == QuestionType.singleChoice) {
                              answers[question.id] = {index};
                            } else {
                              final set = answers[question.id] ?? {};
                              isSelected ? set.remove(index) : set.add(index);
                              answers[question.id] = set;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blueAccent.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.white24,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              question.type == QuestionType.singleChoice
                                  ? Radio<int>(
                                value: index,
                                groupValue: selected.isEmpty
                                    ? null
                                    : selected.first,
                                activeColor: Colors.blueAccent,
                                onChanged: (_) {
                                  setState(() {
                                    answers[question.id] = {index};
                                  });
                                },
                              )
                                  : Checkbox(
                                value: isSelected,
                                activeColor: Colors.blueAccent,
                                onChanged: (_) {
                                  setState(() {
                                    final set =
                                        answers[question.id] ?? {};
                                    isSelected
                                        ? set.remove(index)
                                        : set.add(index);
                                    answers[question.id] = set;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  if (currentQuestionIndex > 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white24,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => currentQuestionIndex--);
                      },
                      child: const Text("Previous"),
                    )
                  else
                    const SizedBox(width: 100), // Placeholder

                  // Next / Finish button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: selected.isNotEmpty ? () {
                      if (currentQuestionIndex <
                          widget.story.questions.length - 1) {
                        setState(() => currentQuestionIndex++);
                      } else {
                        // Last question → Save score & go to next story
                        goToNext();
                      }
                    } : null,
                    child: Text(
                      currentQuestionIndex ==
                          widget.story.questions.length - 1
                          ? "Finish & Next Story"
                          : "Next",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CompletionScreen extends StatelessWidget {
  final List<StoryResult> results;

  const CompletionScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    // Calculate total
    int totalCorrect =
    results.fold(0, (sum, r) => sum + r.correctAnswers);
    int totalQuestions =
    results.fold(0, (sum, r) => sum + r.totalQuestions);
    double overallPercent = (totalCorrect / totalQuestions);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.emoji_events,
                  size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              const Text(
                "Assessment Complete!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your performance summary",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),

              // Per-story cards
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final r = results[index];
                    double percent = r.correctAnswers / r.totalQuestions;
                    return Card(
                      color: Colors.blueGrey[900],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${r.storyTitle}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            LinearPercentIndicator(
                              lineHeight: 10,
                              percent: percent,
                              backgroundColor: Colors.white24,
                              progressColor: Colors.blueAccent,
                              barRadius:
                              const Radius.circular(8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${r.correctAnswers} / ${r.totalQuestions} correct (${(percent * 100).toStringAsFixed(1)}%)",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Overall score
              Card(
                color: Colors.blueGrey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Overall Score",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$totalCorrect / $totalQuestions correct",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      LinearPercentIndicator(
                        lineHeight: 12,
                        percent: overallPercent,
                        backgroundColor: Colors.white24,
                        progressColor: Colors.greenAccent,
                        barRadius: const Radius.circular(8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${(overallPercent * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(
                      context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

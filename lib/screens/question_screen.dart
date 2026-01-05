import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/question.dart';
import 'story_listening_screen.dart';
import '../data/stories.dart';

class QuestionScreen extends StatefulWidget {
  final Story story;
  const QuestionScreen({super.key, required this.story});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final Map<String, Set<int>> answers = {};

  bool get allAnswered =>
      widget.story.questions.every((q) => answers[q.id]?.isNotEmpty == true);

  void goToNextStory() {
    int currentIndex =
        stories.indexWhere((s) => s.id == widget.story.id);
    if (currentIndex < stories.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              StoryListeningScreen(story: stories[currentIndex + 1]),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CompletionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Answer Questions")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...widget.story.questions.map(buildQuestion).toList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: allAnswered ? goToNextStory : null,
              child: const Text("Continue"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(Question q) {
    final selected = answers[q.id] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        ...List.generate(q.options.length, (index) {
          final isSelected = selected.contains(index);
          return ListTile(
            title: Text(q.options[index]),
            leading: q.type == QuestionType.singleChoice
                ? Radio<int>(
                    value: index,
                    groupValue: selected.isEmpty ? null : selected.first,
                    onChanged: (value) {
                      setState(() {
                        answers[q.id] = {value!};
                      });
                    },
                  )
                : Checkbox(
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        final set = answers[q.id] ?? {};
                        checked! ? set.add(index) : set.remove(index);
                        answers[q.id] = set;
                      });
                    },
                  ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assessment Complete")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text("You have completed all stories!", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

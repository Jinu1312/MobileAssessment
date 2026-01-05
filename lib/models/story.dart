import 'package:mobile_assessment/models/question.dart';

class Story {
  final String id;
  final String title;
  final List<String> segments; // Spoken chunks
  final List<Question> questions;

  Story({
    required this.id,
    required this.title,
    required this.segments,
    required this.questions,
  });
}

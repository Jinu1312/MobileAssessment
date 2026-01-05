enum QuestionType {
  singleChoice,
  multiChoice,
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final Set<int> correctAnswers;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswers,
  });
}

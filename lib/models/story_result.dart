class StoryResult {
  final String storyId;
  final String storyTitle;
  final int correctAnswers;
  final int totalQuestions;

  StoryResult({
    required this.storyId,
    required this.storyTitle,
    required this.correctAnswers,
    required this.totalQuestions,
  });
}

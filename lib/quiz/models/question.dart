import 'package:html_unescape/html_unescape.dart';

class Question {
  final String question;
  final List<String> answers;
  final String correctAnswer;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  factory Question.fromOpenTDB(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    final q = unescape.convert(json['question'] as String);
    final correct = unescape.convert(json['correct_answer'] as String);
    final incorrect = (json['incorrect_answers'] as List)
        .map((e) => unescape.convert(e as String))
        .cast<String>()
        .toList();
    final all = [...incorrect, correct]..shuffle();
    return Question(question: q, answers: all, correctAnswer: correct);
  }
}

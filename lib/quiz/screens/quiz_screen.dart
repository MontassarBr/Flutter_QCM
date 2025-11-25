import 'package:flutter/material.dart';
import 'package:qcmed/quiz/models/question.dart';
import 'package:qcmed/quiz/models/quiz_category.dart';
import 'package:qcmed/quiz/screens/result_screen.dart';
import 'package:qcmed/quiz/services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  const QuizScreen({
    super.key,
    required this.category,
    VoidCallback? onToggleTheme,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _service = QuizService();
  late Future<List<Question>> _future;
  List<Question> _questions = [];
  int _index = 0;
  int _score = 0;
  String? _selected;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchQuestions(
      categoryId: widget.category.id,
      amount: 10,
    );
  }

  void _selectAnswer(String answer) {
    if (_locked) return;
    final q = _questions[_index];
    setState(() {
      _selected = answer;
      _locked = true;
      if (answer == q.correctAnswer) {
        _score++;
      }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_index + 1 < _questions.length) {
        setState(() {
          _index++;
          _selected = null;
          _locked = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              score: _score,
              total: _questions.length,
              category: widget.category,
            ),
          ),
        );
      }
    });
  }

  Widget _buildQuestion(Question q) {
    final progress = (_index + 1) / _questions.length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 15),
            Text(
              'Question ${_index + 1}/${_questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.center,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    q.question,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 75),
            ...q.answers.map((a) {
              final isCorrect = a == q.correctAnswer;
              final isSelected = _selected == a;
              Color? bg;
              Color? fg;
              if (_locked) {
                if (isCorrect) {
                  bg = Colors.green.shade600;
                  fg = Colors.white;
                } else if (isSelected) {
                  bg = Colors.red.shade600;
                  fg = Colors.white;
                }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Align(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _selectAnswer(a),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bg,
                          foregroundColor: fg,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 40,
                          ),
                        ),
                        child: Text(a, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name), centerTitle: true),
      body: FutureBuilder<List<Question>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _future = _service.fetchQuestions(
                          categoryId: widget.category.id,
                          amount: 10,
                        );
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          _questions = snapshot.data ?? [];
          if (_questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Aucune question trouvée.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _future = _service.fetchQuestions(
                          categoryId: widget.category.id,
                          amount: 10,
                        );
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          return _buildQuestion(_questions[_index]);
        },
      ),
    );
  }
}

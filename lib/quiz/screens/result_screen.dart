import 'package:flutter/material.dart';
import 'package:qcmed/quiz/models/quiz_category.dart';
import 'package:qcmed/quiz/screens/quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final QuizCategory category;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : score / total;
    final theme = Theme.of(context);
    String title;
    IconData icon;
    if (ratio >= 0.8) {
      title = 'Excellent !';
      icon = Icons.emoji_events_rounded;
    } else if (ratio >= 0.5) {
      title = 'Bien joué !';
      icon = Icons.thumb_up_alt_rounded;
    } else {
      title = "C'est un bon début";
      icon = Icons.lightbulb_rounded;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Résultat'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(icon, size: 36, color: theme.colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Tu as obtenu $score / $total',
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(category: category),
                    ),
                  );
                },
                child: const Text('Rejouer cette catégorie'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Changer de catégorie"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

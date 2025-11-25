import 'package:flutter/material.dart';
import 'package:qcmed/quiz/models/quiz_category.dart';
import 'package:qcmed/quiz/screens/quiz_screen.dart';
import 'package:qcmed/quiz/services/quiz_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  const HomeScreen({super.key, required this.isDark, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = QuizService();
  late Future<List<QuizCategory>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchCategories();
  }

  IconData _iconForCategory(QuizCategory c) {
    switch (c.id) {
      case 9:
        return Icons.public;
      case 10:
        return Icons.menu_book_outlined;
      case 11:
        return Icons.local_movies_outlined;
      case 12:
        return Icons.music_note_outlined;
      case 13:
        return Icons.theaters_outlined;
      case 14:
        return Icons.tv;
      case 15:
        return Icons.sports_esports_outlined;
      case 16:
        return Icons.casino_outlined;
      case 17:
        return Icons.biotech_outlined;
      case 18:
        return Icons.computer;
      case 19:
        return Icons.calculate_outlined;
      case 20:
        return Icons.psychology_outlined;
      case 21:
        return Icons.sports_soccer;
      case 22:
        return Icons.map_outlined;
      case 23:
        return Icons.history_edu_outlined;
      case 24:
        return Icons.gavel_outlined;
      case 25:
        return Icons.palette_outlined;
      case 26:
        return Icons.star_outline;
      case 27:
        return Icons.pets_outlined;
      case 28:
        return Icons.directions_car_outlined;
      case 29:
        return Icons.auto_stories_outlined;
      case 30:
        return Icons.devices_other;
      case 31:
        return Icons.theaters_outlined;
      case 32:
        return Icons.emoji_emotions_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.fetchCategories();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Quiz'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: FutureBuilder<List<QuizCategory>>(
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
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _future = _service.fetchCategories();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          final categories = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final c = categories[index];
                return Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(category: c),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(_iconForCategory(c)),
                        ),
                        title: Text(c.name),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

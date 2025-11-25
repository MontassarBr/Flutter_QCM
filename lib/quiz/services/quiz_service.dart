import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qcmed/quiz/models/question.dart';
import 'package:qcmed/quiz/models/quiz_category.dart';

class QuizService {
  final http.Client _client;

  QuizService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<QuizCategory>> fetchCategories() async {
    final uri = Uri.parse('https://opentdb.com/api_category.php');
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Erreur réseau: ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['trivia_categories'] as List?) ?? [];
    return list
        .map((e) => QuizCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Question>> fetchQuestions({
    required int categoryId,
    int amount = 10,
    String? type,
  }) async {
    final params = <String, String>{
      'amount': amount.toString(),
      'category': categoryId.toString(),
    };
    if (type != null) params['type'] = type;

    final uri = Uri.https('opentdb.com', '/api.php', params);
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Erreur réseau: ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    if ((data['response_code'] as num).toInt() != 0) {
      throw Exception('Aucune question disponible pour cette catégorie.');
    }
    final results = (data['results'] as List?) ?? [];
    return results
        .map((e) => Question.fromOpenTDB(e as Map<String, dynamic>))
        .toList();
  }
}

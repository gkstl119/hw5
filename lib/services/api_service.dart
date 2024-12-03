import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  static Future<List<Question>> fetchQuestions(
      int amount, int categoryId, String difficulty, String type) async {
    final url =
        'https://opentdb.com/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=$type';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((questionData) => Question.fromJson(questionData))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

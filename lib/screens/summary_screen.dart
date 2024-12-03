import 'package:flutter/material.dart';
import '../models/question.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Question> questions;

  SummaryScreen({
    required this.score,
    required this.totalQuestions,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Your Score: $score/$totalQuestions'),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return ListTile(
                    title: Text(question.question),
                    subtitle: Text('Answer: ${question.correctAnswer}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Back to Setup'),
            ),
          ],
        ),
      ),
    );
  }
}

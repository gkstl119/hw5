import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import 'summary_screen.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final int categoryId;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.numberOfQuestions,
    required this.categoryId,
    required this.difficulty,
    required this.type,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _feedbackText = "";
  late Timer _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          _submitAnswer(null); // Time's up
        }
      });
    });
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions(
        widget.numberOfQuestions,
        widget.categoryId,
        widget.difficulty,
        widget.type,
      );
      setState(() {
        _questions = questions;
        _loading = false;
      });
      _startTimer();
    } catch (e) {
      print(e);
    }
  }

  void _submitAnswer(String? selectedAnswer) {
    _timer.cancel();
    setState(() {
      _answered = true;
      final correctAnswer = _questions[_currentQuestionIndex].correctAnswer;
      if (selectedAnswer == correctAnswer) {
        _score++;
        _feedbackText = "Correct!";
      } else if (selectedAnswer == null) {
        _feedbackText = "Time's up! Correct answer: $correctAnswer.";
      } else {
        _feedbackText = "Incorrect! Correct answer: $correctAnswer.";
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _answered = false;
        _currentQuestionIndex++;
        _feedbackText = "";
        _timeLeft = 15;
      });
      _startTimer();
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          score: _score,
          totalQuestions: _questions.length,
          questions: _questions,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Score: $_score', style: TextStyle(fontSize: 18)),
            Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
            ),
            SizedBox(height: 16),
            Text('Time Left: $_timeLeft seconds',
                style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            Text(question.question),
            ...question.options.map((option) {
              return ElevatedButton(
                onPressed: _answered ? null : () => _submitAnswer(option),
                child: Text(option),
              );
            }),
            if (_answered) Text(_feedbackText),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text('Next'),
              ),
          ],
        ),
      ),
    );
  }
}

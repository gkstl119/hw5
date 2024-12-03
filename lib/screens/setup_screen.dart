import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _numberOfQuestions = 10;
  String _selectedCategory = 'General Knowledge';
  String _selectedDifficulty = 'easy';
  String _selectedType = 'multiple';

  final Map<String, int> _categories = {
    'General Knowledge': 9,
    'Sports': 21,
    'Movies': 11,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Number of Questions:', style: TextStyle(fontSize: 18)),
            DropdownButton<int>(
              value: _numberOfQuestions,
              onChanged: (value) {
                setState(() {
                  _numberOfQuestions = value!;
                });
              },
              items: [5, 10, 15]
                  .map((num) => DropdownMenuItem<int>(
                        value: num,
                        child: Text('$num'),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text('Category:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: _categories.keys
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text('Difficulty:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedDifficulty,
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
              items: ['easy', 'medium', 'hard']
                  .map((difficulty) => DropdownMenuItem<String>(
                        value: difficulty,
                        child: Text(difficulty),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text('Type:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              items: ['multiple', 'boolean']
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type == 'multiple'
                            ? 'Multiple Choice'
                            : 'True/False'),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      numberOfQuestions: _numberOfQuestions,
                      categoryId: _categories[_selectedCategory]!,
                      difficulty: _selectedDifficulty,
                      type: _selectedType,
                    ),
                  ),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

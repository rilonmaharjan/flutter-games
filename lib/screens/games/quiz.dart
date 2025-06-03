import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({super.key});

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'answers': ['London', 'Paris', 'Berlin', 'Madrid'],
      'correctIndex': 1,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'answers': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correctIndex': 1,
    },
    {
      'question': 'What is the largest mammal?',
      'answers': ['Elephant', 'Blue Whale', 'Giraffe', 'Polar Bear'],
      'correctIndex': 1,
    },
    {
      'question': 'Which language is Flutter based on?',
      'answers': ['Java', 'Kotlin', 'Dart', 'Swift'],
      'correctIndex': 2,
    },
  ];

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestionIndex]['correctIndex']) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Game', style: GoogleFonts.poppins()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _quizCompleted
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Quiz Completed!',
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Score: $_score/${_questions.length}',
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _resetQuiz,
                      child: Text('Restart Quiz', style: GoogleFonts.poppins(fontSize: 18)),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      _questions[_currentQuestionIndex]['answers'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue[700],
                          ),
                          onPressed: () => _answerQuestion(index),
                          child: Text(
                            _questions[_currentQuestionIndex]['answers'][index],
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Score: $_score',
                      style: GoogleFonts.poppins(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
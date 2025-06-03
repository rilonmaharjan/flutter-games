import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapGame extends StatefulWidget {
  const TapGame({super.key});

  @override
  State<TapGame> createState() => _TapGameState();
}

class _TapGameState extends State<TapGame> {
  int score = 0;
  int timeLeft = 30;
  bool gameActive = false;
  late Timer timer;
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  // Load high score from SharedPreferences
  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('taphighScore') ?? 0;
    });
  }

  // Save high score to SharedPreferences
  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('taphighScore', highScore);
  }

  void _startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameActive = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          gameActive = false;
          // Update high score if needed
          if (score > highScore) {
            highScore = score;
            _saveHighScore();
          }
        }
      });
    });
  }

  void _incrementScore() {
    if (gameActive) {
      setState(() {
        score++;
      });
    }
  }

  @override
  void dispose() {
    if (gameActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tap Game', style: GoogleFonts.poppins()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: GoogleFonts.poppins(fontSize: 36),
            ),
            Text(
              'High Score: $highScore',
              style: GoogleFonts.poppins(fontSize: 24, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            Text(
              'Time: $timeLeft',
              style: GoogleFonts.poppins(fontSize: 24),
            ),
            const SizedBox(height: 40),
            if (!gameActive)
              ElevatedButton(
                onPressed: _startGame,
                child: Text(
                  'Start Game',
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
              ),
            if (gameActive)
              GestureDetector(
                onTap: _incrementScore,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'TAP!',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().scale(duration: 200.ms).then().shake(),
                  ),
                ),
              ),
            if (timeLeft <= 0)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'Game Over!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

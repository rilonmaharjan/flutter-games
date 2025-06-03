import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minigames/screens/games/dinorun.dart';
import 'package:minigames/screens/games/memory.dart';
import 'package:minigames/screens/games/quiz.dart';
import 'package:minigames/screens/games/snake.dart';
import 'package:minigames/screens/games/spaceshooter.dart';
import 'package:minigames/screens/games/tap.dart';
import 'package:minigames/screens/games/tictactoe.dart';

class RealGames extends StatelessWidget {
  const RealGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          GameCard(
            title: 'Tic-Tac-Toe',
            icon: Text('❌⭕', style: TextStyle(fontSize: 28)),
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TicTacToeGame()),
              );
            },
          ),
          GameCard(
            title: 'Memory Game',
            icon: Text('🧠', style: TextStyle(fontSize: 35)),
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MemoryGame()),
              );
            },
          ),
          GameCard(
            title: 'Tap Game',
            icon: Text('👆', style: TextStyle(fontSize: 45)),
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TapGame()),
              );
            },
          ),
          GameCard(
            title: 'Snake Game',
            icon: Text('🐍', style: TextStyle(fontSize: 45)),
            color: Colors.purple,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SnakeGame())),
          ),
          GameCard(
            title: 'Quiz Game',
            icon: Text('❓', style: TextStyle(fontSize: 45)),
            color: Colors.red,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizGame())),
          ),
          GameCard(
            title: 'Space Shooter',
            icon: Text('🚀', style: TextStyle(fontSize: 45)),
            color: Colors.indigo,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SpaceShooterGame())),
          ),
          GameCard(
            title: 'Dino Run',
            icon: Text('🦖', style: TextStyle(fontSize: 45)),
            color: Colors.indigo,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DinoRunGame())),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final dynamic icon;
  final Color color;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minigames/screens/games/avoidbomb.dart';
import 'package:minigames/screens/games/dinorun.dart';
import 'package:minigames/screens/games/memory.dart';
import 'package:minigames/screens/games/quiz.dart';
import 'package:minigames/screens/games/snake.dart';
import 'package:minigames/screens/games/spaceshooter.dart';
import 'package:minigames/screens/games/tap.dart';
import 'package:minigames/screens/games/tictactoe.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class RealGames extends StatelessWidget {
  const RealGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              _buildGameCard(
                context,
                title: 'Tic-Tac-Toe',
                emoji: '❌⭕',
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                game: const TicTacToeGame(),
              ),
              _buildGameCard(
                context,
                title: 'Memory Game',
                emoji: '🧠',
                colors: [Colors.orange.shade400, Colors.orange.shade600],
                game: const MemoryGame(),
              ),
              _buildGameCard(
                context,
                title: 'Tap Game',
                emoji: '👆',
                colors: [Colors.green.shade400, Colors.green.shade600],
                game: const TapGame(),
              ),
              _buildGameCard(
                context,
                title: 'Snake Game',
                emoji: '🐍',
                colors: [Colors.purple.shade400, Colors.purple.shade600],
                game: const SnakeGame(),
              ),
              _buildGameCard(
                context,
                title: 'Quiz Game',
                emoji: '❓',
                colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                game: const QuizGame(),
              ),
              _buildGameCard(
                context,
                title: 'Space Shooter',
                emoji: '🚀',
                colors: [Colors.teal.shade400, Colors.teal.shade600],
                game: const SpaceShooterGame(),
              ),
              _buildGameCard(
                context,
                title: 'Dino Run',
                emoji: '🦖',
                colors: [const Color.fromARGB(255, 121, 59, 58), Colors.red.shade600],
                game: const DinoRunGame(),
              ),
              _buildGameCard(
                context,
                title: 'Avoid Bomb',
                emoji: '💣',
                colors: [Colors.deepOrange.shade400, Colors.deepOrange.shade600],
                game: const AvoidTheBombGame(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, {
    required String title,
    required String emoji,
    required List<Color> colors,
    required Widget game,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) => game,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..scale(1.0),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
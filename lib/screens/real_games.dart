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
                colors: [const Color.fromARGB(235, 66, 164, 245), const Color.fromARGB(235, 12, 87, 153)],
                game: const TicTacToeGame(),
              ),
              _buildGameCard(
                context,
                title: 'Memory Game',
                emoji: '🧠',
                colors: [const Color.fromARGB(237, 255, 168, 38), const Color.fromARGB(237, 146, 84, 7)],
                game: const MemoryGame(),
              ),
              _buildGameCard(
                context,
                title: 'Tap Game',
                emoji: '👆',
                colors: [const Color.fromARGB(237, 102, 187, 106), const Color.fromARGB(232, 67, 160, 72)],
                game: const TapGame(),
              ),
              _buildGameCard(
                context,
                title: 'Snake Game',
                emoji: '🐍',
                colors: [const Color.fromARGB(238, 173, 75, 190), const Color.fromARGB(230, 111, 15, 138)],
                game: const SnakeGame(),
              ),
              _buildGameCard(
                context,
                title: 'Quiz Game',
                emoji: '❓',
                colors: [const Color.fromARGB(237, 92, 107, 192), const Color.fromARGB(230, 45, 58, 145)],
                game: const QuizGame(),
              ),
              _buildGameCard(
                context,
                title: 'Space Shooter',
                emoji: '🚀',
                colors: [const Color.fromARGB(221, 61, 216, 200), const Color.fromARGB(218, 5, 117, 106)],
                game: const SpaceShooterGame(),
              ),
              _buildGameCard(
                context,
                title: 'Dino Run',
                emoji: '🦖',
                colors: [const Color.fromARGB(230, 229, 56, 53),const Color.fromARGB(255, 121, 59, 58)],
                game: const DinoRunGame(),
              ),
              _buildGameCard(
                context,
                title: 'Avoid Bomb',
                emoji: '💣',
                colors: [const Color.fromARGB(242, 238, 115, 78), const Color.fromARGB(227, 143, 45, 15)],
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
              color: colors.last.withValues(alpha: 0.3),
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
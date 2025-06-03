import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DinoRunGame extends StatefulWidget {
  const DinoRunGame({super.key});

  @override
  State<DinoRunGame> createState() => _DinoRunGameState();
}

class _DinoRunGameState extends State<DinoRunGame> {
  // Game constants
  static const double gravity = 0.0008;
  static const double jumpVelocity = 0.02;
  static const double initialObstacleSpeed = 0.01;
  static const double groundHeight = 0.85;

  // Game state
  double dinoY = groundHeight;
  double dinoVelocity = 0;
  bool isJumping = false;
  double obstacleX = 1.0;
  int score = 0;
  int highScore = 0;
  bool isGameOver = false;
  Timer? gameTimer;
  double gameSpeed = 1.0;
  double obstacleSpeed = initialObstacleSpeed;

  // Dimensions
  final double obstacleWidth = 0.05;
  final double obstacleHeight = 0.1;
  final double dinoWidth = 0.08;
  final double dinoHeight = 0.12;

  @override
  void initState() {
    super.initState();
    loadHighScore();
    startGame();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('dinohighScore') ?? 0;
    });
  }

  void startGame() {
    setState(() {
      dinoY = groundHeight;
      dinoVelocity = 0;
      isJumping = false;
      obstacleX = 1.0;
      score = 0;
      isGameOver = false;
      gameSpeed = 1.0;
      obstacleSpeed = initialObstacleSpeed;
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  void updateGame() {
    if (isGameOver) return;

    // Update dino position
    if (isJumping) {
      dinoVelocity -= gravity;
      dinoY -= dinoVelocity * gameSpeed;

      // Land on ground
      if (dinoY > groundHeight) {
        dinoY = groundHeight;
        isJumping = false;
        dinoVelocity = 0;
      }
    }

    // Update obstacle position
    setState(() {
      obstacleX -= obstacleSpeed * gameSpeed;

      // Reset obstacle when it goes off screen
      if (obstacleX < -obstacleWidth) {
        obstacleX = 1.0;
        score++;

        // Increase speed every 10 points
        if (score % 10 == 0) {
          obstacleSpeed += 0.002;
        }
      }

      // Improved collision detection
      double dinoLeft = 0.2;
      double dinoRight = dinoLeft + dinoWidth;
      double dinoBottom = dinoY;

      double obstacleLeft = obstacleX;
      double obstacleRight = obstacleX + obstacleWidth;
      double obstacleBottom = groundHeight;
      double obstacleTop = obstacleBottom - obstacleHeight;

      bool isHorizontallyOverlapping = dinoRight > obstacleLeft && dinoLeft < obstacleRight;
      bool isVerticallyOverlapping = dinoBottom > obstacleTop;

      if (isHorizontallyOverlapping && isVerticallyOverlapping) {
        gameOver();
      }
    });
  }

  void jump() {
    if (!isJumping && !isGameOver) {
      isJumping = true;
      dinoVelocity = jumpVelocity;
    }
  }

  void gameOver() async {
    setState(() {
      isGameOver = true;
    });
    gameTimer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      setState(() {
        highScore = score;
      });
      await prefs.setInt('dinohighScore', score);
    }

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score\nHigh Score: $highScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
            child: const Text('Play Again'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dinoSize = screenWidth * dinoWidth;
    final obstacleSize = screenWidth * obstacleWidth;

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Dino Run',style: GoogleFonts.poppins(fontSize : 16)),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('High Score: $highScore', style: GoogleFonts.poppins(fontSize : 14)),
                SizedBox(width: 16),
                Text('Score: $score', style: GoogleFonts.poppins(fontSize : 14)),
              ],
            ),
          )
        ],
      ),
      body: InkWell(
        onTap: jump,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Stack(
          children: [
            // Ground
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                color: const Color(0xFF555555),
                child: CustomPaint(
                  painter: _GroundPainter(),
                ),
              ),
            ),

            // Dino
            Positioned(
              left: screenWidth * 0.2,
              bottom: MediaQuery.of(context).size.height * (1 - dinoY) - dinoSize,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.1416), // pi radians = 180 degrees flip horizontally
                child: Text(
                  '🦖',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),

            // Obstacle (cactus)
            Positioned(
              left: screenWidth * obstacleX,
              bottom: MediaQuery.of(context).size.height * (1 - groundHeight),
              child: Container(
                width: obstacleSize,
                height: MediaQuery.of(context).size.height * obstacleHeight,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomPaint(
                  painter: _CactusPainter(),
                ),
              ),
            ),

            // Game over overlay
            if (isGameOver)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    'GAME OVER',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF666666)
      ..strokeWidth = 2;

    // Draw ground lines
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i, size.height * 0.3),
        Offset(i + 15, size.height * 0.3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CactusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E8B57)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw cactus details
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

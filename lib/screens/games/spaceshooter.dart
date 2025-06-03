import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpaceShooterGame extends StatefulWidget {
  const SpaceShooterGame({super.key});

  @override
  State<SpaceShooterGame> createState() => _SpaceShooterGameState();
}

class _SpaceShooterGameState extends State<SpaceShooterGame> {
  double shipX = 0; // from -1 (left) to 1 (right)
  List<Bullet> bullets = [];
  List<Enemy> enemies = [];
  Timer? enemyTimer;
  Timer? bulletTimer;
  Timer? shootingTimer;
  int score = 0;
  int highScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    loadHighScore();
    startGame();
    startGame();
  }

  loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('spacehighScore') ?? 0;
    });
  }

  void startGame() {
    gameOver = false;
    score = 0;
    shipX = 0;
    bullets.clear();
    enemies.clear();

    enemyTimer?.cancel();
    bulletTimer?.cancel();
    shootingTimer?.cancel();

    // Add enemies periodically
    enemyTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!gameOver) {
        addEnemy();
      }
    });

    // Move bullets and enemies periodically
    bulletTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!gameOver) {
        moveBullets();
        moveEnemies();
        checkCollision();
      }
    });

    // Shoot automatically every 2 seconds
    shootingTimer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      if (!gameOver) {
        shoot();
      }
    });
  }

  void addEnemy() {
    double enemyX = (Random().nextDouble() * 2) - 1; // -1 to 1
    setState(() {
      enemies.add(Enemy(x: enemyX, y: -1));
    });
  }

  void moveBullets() {
    setState(() {
      bullets = bullets
          .map((b) => Bullet(x: b.x, y: b.y - 0.05))
          .where((b) => b.y > -1)
          .toList();
    });
  }

  void moveEnemies() {
    setState(() {
      enemies = enemies
          .map((e) => Enemy(x: e.x, y: e.y + 0.02))
          .where((e) => e.y < 1)
          .toList();

      // Check if any enemy reached bottom (game over)
      for (var e in enemies) {
        if (e.y > 0.9) {
          gameOver = true;
          enemyTimer?.cancel();
          bulletTimer?.cancel();
          shootingTimer?.cancel();
          showGameOverDialog();
          break;
        }
      }
    });
  }

  void checkCollision() {
    setState(() {
      List<Enemy> remainingEnemies = [];
      List<Bullet> remainingBullets = List.from(bullets);
      
      for (var e in enemies) {
        bool hit = false;
        for (var b in bullets) {
          // Simple collision check: proximity within 0.1 units
          if ((b.x - e.x).abs() < 0.1 && (b.y - e.y).abs() < 0.1) {
            hit = true;
            score++;
            if (score > highScore) {
              highScore = score;
              SharedPreferences.getInstance().then(
                (prefs) => prefs.setInt('spacehighScore', highScore),
              );
            }
            remainingBullets.remove(b);
            break;
          }
        }
        if (!hit) remainingEnemies.add(e);
      }
      
      enemies = remainingEnemies;
      bullets = remainingBullets;
    });
  }

  void shoot() {
    setState(() {
      bullets.add(Bullet(x: shipX, y: 0.9));
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    enemyTimer?.cancel();
    bulletTimer?.cancel();
    shootingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Space Shooter', style: GoogleFonts.poppins(fontSize : 16)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text('High Score: $highScore', style: GoogleFonts.poppins(fontSize : 14)),
                SizedBox(width: 10.0,),
                Text('Score: $score', style: GoogleFonts.poppins(fontSize : 14)),
              ],
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            // Update shipX between -1 and 1 based on drag
            shipX += details.delta.dx / (MediaQuery.of(context).size.width / 2);
            if (shipX > 1) shipX = 1;
            if (shipX < -1) shipX = -1;
          });
        },
        child: Stack(
          children: [
            // Ship
            Align(
              alignment: Alignment(shipX, 0.9),
              child: Transform.rotate(
                angle: -0.79, // approx -90 degrees (π/2 radians)
                child: Text('🚀', style: TextStyle(fontSize: 60)),
              )
            ),

            // Bullets
            ...bullets.map((b) {
              return Align(
                alignment: Alignment(b.x, b.y),
                child: Text("💥", style: TextStyle(fontSize: 12),)
              );
            }),

            // Enemies
            ...enemies.map((e) {
              return Align(
                alignment: Alignment(e.x, e.y),
                child: Text("🧟", style: TextStyle(fontSize: 26),)
              );
            }),
          ],
        ),
      ),
    );
  }
}

class Bullet {
  final double x, y;
  Bullet({required this.x, required this.y});
}

class Enemy {
  final double x, y;
  Enemy({required this.x, required this.y});
}
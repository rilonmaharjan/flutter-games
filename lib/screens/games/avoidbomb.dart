import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';

import 'package:minigames/widgets/particles_bg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvoidTheBombGame extends StatefulWidget {
  const AvoidTheBombGame({super.key});

  @override
  State<AvoidTheBombGame> createState() => _AvoidTheBombGameState();
}

class _AvoidTheBombGameState extends State<AvoidTheBombGame> {
  double playerX = 0;
  List<Offset> bombs = [];
  List<Offset> coins = [];
  int score = 0;
  int highScore = 0;
  int lives = 3;
  bool gameOver = false;
  late Timer _timer;
  Random random = Random();
  double bombSpeed = 0.01;
  double coinSpeed = 0.015;
  double gameSpeed = 1.0;
  int bombCount = 5;
  int coinCount = 2;
  bool isPaused = false;
  bool isHit = false;

  @override
  void initState() {
    super.initState();
    loadHighScore();
    _startGame();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('bombhighScore') ?? 0;
    });
  }

  void _startGame() {
    score = 0;
    lives = 3;
    gameOver = false;
    isPaused = false;
    playerX = 0;
    bombSpeed = 0.01;
    bombCount = 5;
    coinCount = 2;
    
    bombs = List.generate(bombCount, (_) => Offset(_randomX(), -random.nextDouble()));
    coins = List.generate(coinCount, (_) => Offset(_randomX(), -random.nextDouble()));
    
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!isPaused) {
        setState(() {
          // Move bombs
          for (int i = 0; i < bombs.length; i++) {
            bombs[i] = Offset(bombs[i].dx, bombs[i].dy + bombSpeed * gameSpeed);
          }
          
          // Move coins
          for (int i = 0; i < coins.length; i++) {
            coins[i] = Offset(coins[i].dx, coins[i].dy + coinSpeed * gameSpeed);
          }
          
          _checkCollisions();
          _removeAndAddObjects();
          _increaseDifficulty();
        });
      }
    });
  }

  double _randomX() {
    return (random.nextDouble() * 2 - 1).clamp(-1.0, 1.0);
  }

  void _removeAndAddObjects() {
    // Remove bombs that are off screen and add new ones
    bombs.removeWhere((b) => b.dy > 1.2);
    while (bombs.length < bombCount) {
      bombs.add(Offset(_randomX(), -random.nextDouble()));
    }
    
    // Remove coins that are off screen and add new ones
    coins.removeWhere((c) => c.dy > 1.2);
    while (coins.length < coinCount) {
      coins.add(Offset(_randomX(), -random.nextDouble()));
    }
  }

  void _checkCollisions() {
    // Player position and size
    final playerPos = playerX;
    final playerWidth = 0.14;
    
    // Check bomb collisions
    for (var bomb in bombs) {
      if (bomb.dy > 0.87 && bomb.dy < 0.99) {
        double distance = (bomb.dx - playerPos).abs();
        if (distance < playerWidth) {
          setState(() {
            isHit = true;
            lives--;
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() => isHit = false);
            });
            if (lives <= 0) {
              gameOver = true;
              _timer.cancel();
              storeHighScore();
            }
            // Remove the bomb that hit the player
            bombs.remove(bomb);
            bombs.add(Offset(_randomX(), -random.nextDouble()));
          });
          break;
        }
      }
    }
    
    // Check coin collections
    for (var coin in coins) {
      if (coin.dy > 0.87 && coin.dy < 0.99) {
        double distance = (coin.dx - playerPos).abs();
        if (distance < playerWidth) {
          setState(() {
            score += 10;
            coins.remove(coin);
            coins.add(Offset(_randomX(), -random.nextDouble()));
          });
          break;
        }
      }
    }
    
    // Increment score for survival
    score++;
  }

  void _increaseDifficulty() {
    if (score % 500 == 0) {
      setState(() {
        bombSpeed += 0.001;
        gameSpeed += 0.05;
        if (score % 1000 == 0 && bombCount < 10) {
          bombCount++;
        }
        if (score % 1500 == 0 && coinCount < 5) {
          coinCount++;
        }
      });
    }
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    if (gameOver || isPaused) return;
    setState(() {
      double delta = details.delta.dx / MediaQuery.of(context).size.width * 2;
      playerX = (playerX + delta).clamp(-1.0, 1.0);
    });
  }

  void _resetGame() {
    _timer.cancel();
    _startGame();
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Avoid The Bomb',style: GoogleFonts.poppins(fontSize : 16)),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('High Score: $highScore', style: GoogleFonts.poppins(fontSize : 14)),
                SizedBox(width: 16),
              ],
            ),
          )
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDrag,
        child: Stack(
          children: [
            ParticlesBackground(),
            // Score and Lives
            Positioned(
              top: 10,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score: $score',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    'Lives: ${'❤️' * lives}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            
            // Pause Button
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: _togglePause,
              ),
            ),
            
            // Player
            Align(
              alignment: Alignment(playerX, 0.9),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isHit ? Colors.red : Colors.blue,  // Flash red when hit
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.face, color: Colors.white),
              ),
            ),
            
            // Bombs
            ...bombs.map((bomb) {
              return Positioned(
                top: bomb.dy * MediaQuery.of(context).size.height / 2 +
                    MediaQuery.of(context).size.height / 2,
                left: bomb.dx * MediaQuery.of(context).size.width / 2 +
                    MediaQuery.of(context).size.width / 2 - 16,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha:0.7),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              );
            }),
            
            // Coins
            ...coins.map((coin) {
              return Positioned(
                top: coin.dy * MediaQuery.of(context).size.height / 2 +
                    MediaQuery.of(context).size.height / 2,
                left: coin.dx * MediaQuery.of(context).size.width / 2 +
                    MediaQuery.of(context).size.width / 2 - 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withValues(alpha:0.7),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              );
            }),
            
            // Game Over Screen
            if (gameOver)
              Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Game Over',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Final Score: $score',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _resetGame,
                        child: const Text(
                          'Try Again',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            
            // Pause Screen
            if (isPaused && !gameOver)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Paused',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: _togglePause,
                        child: const Text(
                          'Resume',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  storeHighScore() async{
    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      setState(() {
        highScore = score;
      });
      await prefs.setInt('bombhighScore', score);
    }
  }
}
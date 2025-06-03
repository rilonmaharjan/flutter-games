import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 15;
  final int squaresPerCol = 30;
  final fontStyle = GoogleFonts.poppins(color: Colors.white, fontSize: 14);
  final gameFontStyle = GoogleFonts.poppins(color: Colors.white, fontSize: 36);

  var snake = [
    [0, 1],
    [0, 0]
  ];
  int highScore = 0;
  dynamic food = [0, 2];
  var direction = 'up';
  var isPlaying = false;
  var score = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    loadHighScore();
  }

  void loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('snakehighScore') ?? 0;
    });
  }

  updateHighScore() async {
    if (score > highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('snakehighScore', score);
      setState(() {
        highScore = score;
      });
    }
  }

  void startGame() {
    const duration = Duration(milliseconds: 250); // was 200

    setState(() {
      snake = [
        [(squaresPerRow / 2).floor(), (squaresPerCol / 2).floor()],
      ];
      snake.add([snake.first[0], snake.first[1] + 1]); // one segment below


      createFood();
      isPlaying = true;
      score = 0;
      direction = 'up';
    });

    timer = Timer.periodic(duration, (Timer timer) {
      moveSnake();
      if (checkGameOver()) {
        timer.cancel();
        endGame();
      }
    });
  }

  void moveSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          snake.insert(0, [snake.first[0], snake.first[1] - 1]);
          break;
        case 'down':
          snake.insert(0, [snake.first[0], snake.first[1] + 1]);
          break;
        case 'left':
          snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
          break;
        case 'right':
          snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
          break;
      }

      if (snake.first[0] == food[0] && snake.first[1] == food[1]) {
        score++;
        createFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void createFood() {
    final random = Random();
    food = [
      random.nextInt(squaresPerRow),
      random.nextInt(squaresPerCol),
    ];

    for (var pos in snake) {
      if (pos[0] == food[0] && pos[1] == food[1]) {
        createFood(); // try again if food is on snake
        return;
      }
    }
  }


  bool checkGameOver() {
    // Hit wall
    if (snake.first[0] < 0 ||
        snake.first[0] >= squaresPerRow ||
        snake.first[1] < 0 ||
        snake.first[1] >= squaresPerCol) {
      return true;
    }

    // Hit self
    for (var i = 1; i < snake.length; i++) {
      if (snake.first[0] == snake[i][0] && snake.first[1] == snake[i][1]) {
        return true;
      }
    }
    return false;
  }

  void endGame() async{
    setState(() {
      isPlaying = false;
    });
    await updateHighScore();

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over', style: GoogleFonts.poppins()),
          content: Text('Your score: $score', style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text('Close', style: GoogleFonts.poppins()),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Snake Game', style: GoogleFonts.poppins(fontSize : 16)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text('High Score: $highScore', style: fontStyle),
                SizedBox(width: 16.0,),
                Text('Score: $score', style: fontStyle),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Score and Game Area
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double cellWidth = constraints.maxWidth / squaresPerRow;
                double cellHeight = constraints.maxHeight / squaresPerCol;
                double cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

                return Center(
                  child: SizedBox(
                    width: cellSize * squaresPerRow,
                    height: cellSize * squaresPerCol,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (direction != 'up' && details.delta.dy > 0) {
                          direction = 'down';
                        } else if (direction != 'down' && details.delta.dy < 0) {
                          direction = 'up';
                        }
                      },
                      onHorizontalDragUpdate: (details) {
                        if (direction != 'left' && details.delta.dx > 0) {
                          direction = 'right';
                        } else if (direction != 'right' && details.delta.dx < 0) {
                          direction = 'left';
                        }
                      },
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: squaresPerRow,
                        ),
                        itemCount: squaresPerRow * squaresPerCol,
                        itemBuilder: (BuildContext context, int index) {
                          var color = const Color.fromARGB(150, 63, 63, 63);
                          var x = index % squaresPerRow;
                          var y = (index / squaresPerRow).floor();

                          for (var pos in snake) {
                            if (pos[0] == x && pos[1] == y) {
                              color = Colors.green;
                            }
                          }

                          if (snake.first[0] == x && snake.first[1] == y) {
                            color = const Color.fromARGB(255, 173, 235, 102);
                          }

                          if (food[0] == x && food[1] == y) {
                            color = Colors.red;
                          }

                          // Obstacles
                          // for (var obs in obstacles) {
                          //   if (obs[0] == x && obs[1] == y) {
                          //     color = Colors.brown;
                          //   }
                          // }

                          return AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Game Instructions or Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: isPlaying
                ? SizedBox(
                  height: 60,
                  child: Text(
                      'Use swipe gestures to control the snake',
                      style: fontStyle,
                    ),
                )
                : SizedBox(
                  height: 60,
                  child: ElevatedButton(
                      onPressed: startGame,
                      child: Text('START GAME', style: gameFontStyle),
                    ),
                ),
          ),
        ],
      ),
    );
  }
}

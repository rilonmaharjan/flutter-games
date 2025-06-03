import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late ConfettiController _confettiController;
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  int xScore = 0;
  int oScore = 0;
  int drawScore = 0;
  bool gameOver = false;
  String resultText = '';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: 3.seconds);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _newGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      gameOver = false;
      resultText = '';
    });
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      xScore = 0;
      oScore = 0;
      drawScore = 0;
      gameOver = false;
      resultText = '';
    });
  }

  void _makeMove(int index) {
    if (board[index] != '' || gameOver) return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
    });

    _checkWinner();
  }

  void _checkWinner() {
    const winningCombos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6], // diagonals
    ];

    for (var combo in winningCombos) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[0]] == board[combo[2]]) {
        setState(() {
          gameOver = true;
          if (board[combo[0]] == 'X') {
            xScore++;
            resultText = '🎉 Player X Wins!';
          } else {
            oScore++;
            resultText = '🎉 Player O Wins!';
          }
          _confettiController.play();
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        gameOver = true;
        drawScore++;
        resultText = '🤝 It\'s a draw!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scoreboard
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScoreCard('X', xScore),
                    _buildScoreCard('Draw', drawScore),
                    _buildScoreCard('O', oScore),
                  ],
                ),
                const SizedBox(height: 20),
                // Game board
                SizedBox(
                  width: 300,
                  height: 300,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _makeMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: board[index] != ''
                              ? Text(
                                  board[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: board[index] == 'X' ? Colors.blue : Colors.red,
                                  ),
                                ).animate().fade(duration: 200.ms).scale()
                              : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Result message and play again
                if (gameOver)
                  Column(
                    children: [
                      Text(
                        resultText,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(duration: 500.ms).slide(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _newGame,
                        child: Text(
                          'Play Again',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String player, int score) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            player,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$score',
            style: GoogleFonts.poppins(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<String> cards = [
    '🍎', '🍎', '🍌', '🍌', '🍒', '🍒',
    '🍓', '🍓', '🍊', '🍊', '🍋', '🍋',
    '🍇', '🍇', '🍉', '🍉', '🥝', '🥝',
    '🍍', '🍍',
  ];

  List<bool> cardFlips = [];
  List<bool> cardMatched = [];
  int? firstCardIndex;
  int moves = 0;
  int pairsFound = 0;
  bool processing = false;

  int timeLeft = 60;
  Timer? countdownTimer;
  bool timeOver = false;

  @override
  void initState() {
    super.initState();
    _shuffleCards();
  }

  void _shuffleCards() {
    setState(() {
      cards.shuffle();
      cardFlips = List.filled(cards.length, false);
      cardMatched = List.filled(cards.length, false);
      firstCardIndex = null;
      moves = 0;
      pairsFound = 0;
      timeOver = false;
    });
    _startTimer();
  }

  void _startTimer() {
    countdownTimer?.cancel();
    timeLeft = 60;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        setState(() {
          timeOver = true;
          countdownTimer?.cancel();
        });
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void _flipCard(int index) {
    if (cardFlips[index] || cardMatched[index] || processing || timeOver) return;

    setState(() {
      cardFlips[index] = true;
    });

    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      processing = true;
      moves++;
      if (cards[firstCardIndex!] == cards[index]) {
        // Match found
        setState(() {
          cardMatched[firstCardIndex!] = true;
          cardMatched[index] = true;
          pairsFound++;
        });
        firstCardIndex = null;
        processing = false;
      } else {
        // No match
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            cardFlips[firstCardIndex!] = false;
            cardFlips[index] = false;
            firstCardIndex = null;
            processing = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool gameWon = pairsFound == cards.length ~/ 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _shuffleCards,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Moves: $moves', style: GoogleFonts.poppins(fontSize: 18)),
                Text('Pairs: $pairsFound/${cards.length ~/ 2}', style: GoogleFonts.poppins(fontSize: 18)),
                Text('Time: $timeLeft s', style: GoogleFonts.poppins(fontSize: 18)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _flipCard(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: cardFlips[index] || cardMatched[index]
                          ? Colors.white
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: cardFlips[index] || cardMatched[index]
                      ? Text(
                          cards[index],
                          style: GoogleFonts.poppins(fontSize: 36),
                        ).animate().fade(duration: 200.ms).scale()
                      : const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ),
          if (gameWon)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Congratulations!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'You won in $moves moves!',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _shuffleCards,
                    child: Text(
                      'Play Again',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          if (timeOver && !gameWon)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Time\'s up!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Try again.',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _shuffleCards,
                    child: Text(
                      'Play Again',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

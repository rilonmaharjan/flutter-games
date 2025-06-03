import 'package:flutter/material.dart';
import 'package:minigames/screens/game_detail_screen.dart';
import 'package:minigames/screens/games.dart';
import 'package:minigames/widgets/theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Games App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const GamesScreen(),
        '/game': (context) => const GameDetailScreen(),
      },
    );
  }
}
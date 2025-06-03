import 'package:flutter/material.dart';
import 'package:minigames/screens/game_list_screen.dart';
import 'package:minigames/screens/real_games.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Text("🎮", style: TextStyle(fontSize: 28),), text: 'My Games'),
            Tab(icon: Text("❤️", style: TextStyle(fontSize: 28),), text: 'Popular Games'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RealGames(),
          GamesListScreen(),
        ],
      ),
    );
  }
}
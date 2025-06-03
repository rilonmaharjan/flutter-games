class Game {
  final String id;
  final String title;
  final String genre;
  final double rating;
  final int players;
  final int duration;
  final String imageUrl;
  final String description;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.players,
    required this.duration,
    required this.imageUrl,
    required this.description,
  });
}

final List<Game> games = [
  Game(
    id: '1',
    title: 'Among Us',
    genre: 'Strategy',
    rating: 4.5,
    players: 4,
    duration: 15,
    imageUrl: 'https://cdn.cloudflare.steamstatic.com/steam/apps/945360/header.jpg',
    description: 'A game of teamwork and betrayal...in space! Play with 4-10 players online or via local WiFi as you attempt to prepare your spaceship for departure, but beware as one or more random players among the Crew are Impostors bent on killing everyone!',
  ),
  Game(
    id: '2',
    title: 'Minecraft',
    genre: 'Adventure',
    rating: 4.8,
    players: 8,
    duration: 60,
    imageUrl: 'https://www.minecraft.net/content/dam/games/minecraft/key-art/MC_2020_Game_Image.png',
    description: 'Minecraft is a sandbox video game developed by Mojang Studios. The game was created by Markus "Notch" Persson in the Java programming language.',
  ),
  Game(
    id: '3',
    title: 'Fortnite',
    genre: 'Battle Royale',
    rating: 4.3,
    players: 100,
    duration: 20,
    imageUrl: 'https://cdn2.unrealengine.com/14br-consoles-1920x1080-wlogo-1920x1080-432974386.jpg',
    description: 'Fortnite is an online video game developed by Epic Games and released in 2017. It is available in three distinct game mode versions that otherwise share the same general gameplay and game engine.',
  ),
  Game(
    id: '4',
    title: 'Roblox',
    genre: 'MMO',
    rating: 4.0,
    players: 20,
    duration: 30,
    imageUrl: 'https://images.rbxcdn.com/7d405a8c8b1e0d147a4e1b5e8c51b5b6',
    description: 'Roblox is an online game platform and game creation system developed by Roblox Corporation that allows users to program games and play games created by other users.',
  ),
  Game(
    id: '5',
    title: 'Call of Duty: Warzone',
    genre: 'FPS',
    rating: 4.6,
    players: 150,
    duration: 30,
    imageUrl: 'https://www.callofduty.com/content/dam/atvi/callofduty/cod-touchui/blog/hero/wz/WZ-Season-Three-Announce-TOUT.jpg',
    description: 'Call of Duty: Warzone is a free-to-play battle royale video game released on March 10, 2020, for PlayStation 4, Xbox One, and Microsoft Windows.',
  ),
];
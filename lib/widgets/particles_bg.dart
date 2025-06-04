import 'dart:math';
import 'package:flutter/material.dart';


class ParticlesBackground extends StatefulWidget {
  const ParticlesBackground({super.key});

  @override
  State<ParticlesBackground> createState() => _ParticlesBackgroundState();
}

class _ParticlesBackgroundState extends State<ParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate stars
    for (int i = 0; i < 200; i++) {
      stars.add(Star.random());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        for (var star in stars) {
          star.update();
        }
        return CustomPaint(
          painter: StarfieldPainter(stars),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Star {
  double x, y, radius, speed, twinklePhase;
  final Paint paint;

  Star._(this.x, this.y, this.radius, this.speed, this.twinklePhase)
      : paint = Paint();

  static final Random _rand = Random();

  static Star random() {
    return Star._(
      _rand.nextDouble(), // x: 0 to 1
      _rand.nextDouble(), // y: 0 to 1
      _rand.nextDouble() * 1.5 + 0.5, // radius: 0.5 to 2.0
      _rand.nextDouble() * 0.002 + 0.0002, // speed
      _rand.nextDouble() * 2 * pi, // twinkle phase
    );
  }

  void update() {
    y += speed;
    if (y > 1) y = 0;

    twinklePhase += 0.05;
    if (twinklePhase > 2 * pi) {
      twinklePhase -= 2 * pi;
    }
  }

  void draw(Canvas canvas, Size size) {
    final brightness = 0.6 + 0.4 * sin(twinklePhase);
    final color = Colors.white.withValues(alpha: brightness);
    paint.color = color;
    canvas.drawCircle(Offset(x * size.width, y * size.height), radius, paint);
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;

  StarfieldPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black,
    );
    for (var star in stars) {
      star.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/screen/onboarding_screen.dart';

// 1️⃣ Particle Data Class
class Particle {
  double x;
  double y;
  double size;
  double speed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> glowAnimation;
  late Animation<double> letterSpacingAnimation;
  late Animation<double> breathingAnimation;

  // 2️⃣ Particle Variables
  final Random random = Random();
  final List<Particle> particles = [];

  @override
  void initState() {
    super.initState();

    // Duration updated to 4 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    glowAnimation = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    letterSpacingAnimation = Tween<double>(
      begin: 14,
      end: -1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    breathingAnimation = Tween<double>(
      begin: 1,
      end: 1.03,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 3️⃣ Initialize Floating Particles
    for (int i = 0; i < 35; i++) {
      particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 4 + 2,
          speed: random.nextDouble() * 0.002 + 0.0005,
        ),
      );
    }

    // 4️⃣ Continuous Breathing & Particle Animation
    _controller.repeat(reverse: true);

    // Navigation Timer
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenDark,
      body: Stack(
        children: [
          /// Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff03120D),
                  Color(0xff0B3B28),
                  Color(0xff1A7A53),
                ],
              ),
            ),
          ),

          /// 5️⃣ Particle Floating Layer
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles,
                  _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),

          /// Dynamic Glow Behind Logo
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 280 + glowAnimation.value * 3,
                  height: 280 + glowAnimation.value * 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.greenAccent.withValues(alpha: .20),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// Main Logo & Subtitle Group
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Transform.scale(
                      scale: scaleAnimation.value * breathingAnimation.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Angkor Fashion",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              letterSpacing: letterSpacingAnimation.value,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withValues(alpha: .4),
                                  blurRadius: glowAnimation.value,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Opacity(
                            opacity: fadeAnimation.value,
                            child: const Text(
                              "Shop Smarter Everyday",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 6️⃣ Custom Particle Painter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(
    this.particles,
    this.animationValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .18);

    for (final particle in particles) {
      double y = particle.y - particle.speed * animationValue * 300;

      if (y < 0) {
        y = 1;
      }

      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
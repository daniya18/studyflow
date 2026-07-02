import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../painters/premium_ring_painter.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1D4ED8),
              Color(0xFF06B6D4),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glowing Background
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.35),
                          blurRadius: 80,
                          spreadRadius: 25,
                        ),
                      ],
                    ),
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scaleXY(
                        begin: 0.95,
                        end: 1.05,
                        duration: 2200.ms,
                        curve: Curves.easeInOut,
                      ),

                  // Rotating Ring
                  RotationTransition(
                    turns: _controller,
                    child: CustomPaint(
                      size: const Size(340, 340),
                      painter: PremiumRingPainter(),
                    ),
                  ),

                  // Floating Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 300,
                    height: 300,
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .moveY(
                        begin: -15,
                        end: 15,
                        duration: 2500.ms,
                        curve: Curves.easeInOutSine,
                      )
                      .fadeIn(duration: 900.ms),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "StudyFlow",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent,
                      blurRadius: 25,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 900.ms)
                  .slideY(begin: 0.4, end: 0),

              const SizedBox(height: 12),

              const Text(
                "Learn Smarter. Study Better.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                  letterSpacing: 1,
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
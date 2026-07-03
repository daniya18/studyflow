import 'dart:math';
import 'package:flutter/material.dart';

class GlowingLogo extends StatefulWidget {
  final double size;

  const GlowingLogo({
    super.key,
    this.size = 100,
  });

  @override
  State<GlowingLogo> createState() => _GlowingLogoState();
}

class _GlowingLogoState extends State<GlowingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final glow = 15 + (_controller.value * 25);

        return Transform.scale(
          scale: 1 + (_controller.value * .05),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xff7C3AED),
                  Color(0xff06B6D4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff7C3AED).withOpacity(.5),
                  blurRadius: glow,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: const Color(0xff06B6D4).withOpacity(.35),
                  blurRadius: glow + 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        );
      },
    );
  }
}
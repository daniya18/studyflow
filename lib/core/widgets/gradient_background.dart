import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class GradientBackground extends StatefulWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
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
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(
                    -1 + _controller.value,
                    -1,
                  ),
                  end: Alignment(
                    1,
                    1 - _controller.value,
                  ),
                  colors: const [
                    Color(0xff09090B),
                    Color(0xff13132B),
                    Color(0xff24164E),
                    Color(0xff09090B),
                  ],
                ),
              ),
            ),

            const _GlowCircle(
              top: -120,
              left: -80,
              size: 260,
              color: Color(0xff7C3AED),
            ),

            const _GlowCircle(
              bottom: -80,
              right: -60,
              size: 240,
              color: Color(0xff06B6D4),
            ),

            const _GlowCircle(
              top: 260,
              right: -70,
              size: 180,
              color: Color(0xffA855F7),
            ),

            ...List.generate(
              20,
              (index) => _Particle(
                index: index,
                animation: _controller,
              ),
            ),

            widget.child,
          ],
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 80,
          sigmaY: 80,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(.35),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _Particle extends StatelessWidget {
  final int index;
  final Animation<double> animation;

  const _Particle({
    required this.index,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(index);

    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    final size = random.nextDouble() * 4 + 2;

    return Positioned(
      left: left,
      top: top +
          sin(animation.value * 2 * pi + index) * 15,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white38,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
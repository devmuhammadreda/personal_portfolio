import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_accents.dart';

/// Lightweight animated backdrop: drifting translucent orbs on a soft
/// radial gradient. Runs a single repeating controller; ignores pointers.
final class FloatingParticlesBackground extends StatefulWidget {
  const FloatingParticlesBackground({super.key, this.orbCount = 24});

  final int orbCount;

  @override
  State<FloatingParticlesBackground> createState() =>
      _FloatingParticlesBackgroundState();
}

class _FloatingParticlesBackgroundState
    extends State<FloatingParticlesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Orb> _orbs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    final math.Random random = math.Random(7);
    _orbs = List<_Orb>.generate(widget.orbCount, (index) {
      return _Orb(
        baseX: random.nextDouble(),
        baseY: random.nextDouble(),
        radius: 2 + random.nextDouble() * 5,
        speedX: 0.02 + random.nextDouble() * 0.06,
        speedY: 0.03 + random.nextDouble() * 0.08,
        phase: random.nextDouble() * math.pi * 2,
        colorIndex: index % 3,
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> particleColors = context.accents.particleColors;
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.8, -0.6),
                radius: 1.4,
                colors: isDark
                    ? [
                        particleColors.first.withValues(alpha: 0.16),
                        Colors.transparent,
                      ]
                    : [
                        particleColors.first.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.9, 0.8),
                radius: 1.2,
                colors: isDark
                    ? [
                        particleColors.last.withValues(alpha: 0.10),
                        Colors.transparent,
                      ]
                    : [
                        particleColors.last.withValues(alpha: 0.07),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _OrbsPainter(_orbs, _controller.value, particleColors),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Orb {
  const _Orb({
    required this.baseX,
    required this.baseY,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.phase,
    required this.colorIndex,
  });

  final double baseX;
  final double baseY;
  final double radius;
  final double speedX;
  final double speedY;
  final double phase;
  final int colorIndex;
}

class _OrbsPainter extends CustomPainter {
  const _OrbsPainter(this.orbs, this.progress, this.particleColors);

  final List<_Orb> orbs;
  final double progress;
  final List<Color> particleColors;

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final double dx =
          (orb.baseX + progress * orb.speedX) % 1.1 -
          0.05 +
          0.04 * math.sin(progress * 2 * math.pi + orb.phase);
      final double dy =
          (orb.baseY - progress * orb.speedY) % 1.1 -
          0.05 +
          0.04 * math.cos(progress * 2 * math.pi + orb.phase);
      final Offset center = Offset(dx * size.width, dy * size.height);
      final Paint paint = Paint()
        ..color = particleColors[orb.colorIndex].withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(center, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbsPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      !listEquals(oldDelegate.particleColors, particleColors);
}

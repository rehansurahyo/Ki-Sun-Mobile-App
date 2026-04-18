import 'dart:math' as math;
import 'package:flutter/material.dart';

class SunnyLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const SunnyLoader({Key? key, this.size = 50.0, this.color}) : super(key: key);

  @override
  State<SunnyLoader> createState() => _SunnyLoaderState();
}

class _SunnyLoaderState extends State<SunnyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return CustomPaint(
            painter: _SunnyLoaderPainter(
              animationValue: _controller.value,
              color: widget.color ?? const Color(0xFFF3BA12), // Default Gold
            ),
          );
        },
      ),
    );
  }
}

class _SunnyLoaderPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _SunnyLoaderPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 1. Rotating Outer Arc
    paint.strokeWidth = 3;
    paint.shader = SweepGradient(
      colors: [
        color.withValues(alpha: 0.1),
        color.withValues(alpha: 0.5),
        color,
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(animationValue * 2 * math.pi),
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      0,
      2 * math.pi,
      false,
      paint,
    );

    // 2. Pulsing Inner Circle
    final pulseValue = math.sin(animationValue * 2 * math.pi); // -1 to 1
    final innerRadius = (radius * 0.4) + (pulseValue * (radius * 0.1));

    final innerPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    // Create a "Sun" glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(center, innerRadius + 2, glowPaint);
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _SunnyLoaderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}

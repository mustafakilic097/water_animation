library water_animation;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that displays a water animation effect with customizable parameters.
///
/// This widget simulates water using animated waves and supports:
/// - A primary wave with configurable amplitude, frequency, and speed.
/// - Optional linear gradient fill for the water surface.
/// - Optional ripple effect when the water is tapped.
/// - An optional secondary wave layer with separate parameters.
/// - Customizable width and height.
class WaterAnimation extends StatefulWidget {
  /// The width of the widget. (Default is 250.)
  final double width;

  /// The height of the widget. (Default is 200.)
  final double height;

  /// The amplitude of the primary wave. (Default is 20.)
  final double amplitude;

  /// The frequency of the primary wave (number of complete waves across the width). (Default is 1.)
  final double frequency;

  /// The speed at which the primary wave moves. (Default is 3.)
  final double speed;

  /// The color of the primary wave. (Default is Colors.blue.)
  final Color waterColor;

  /// If provided, the water is filled with a linear gradient instead of a solid color.
  final List<Color>? gradientColors;

  /// Enables a ripple effect when the water surface is tapped. (Default is false.)
  final bool enableRipple;

  /// Enables shader effects. (Default is false; reserved for future use.)
  final bool enableShader;

  /// Enables a secondary wave layer behind the primary wave. (Default is false.)
  final bool enableSecondWave;

  /// The color of the secondary wave. (Default is Colors.blueAccent.)
  final Color secondWaveColor;

  /// The amplitude of the secondary wave. (Default is 10.0.)
  final double secondWaveAmplitude;

  /// The frequency of the secondary wave. (Default is 1.5.)
  final double secondWaveFrequency;

  /// The speed at which the secondary wave moves. (Default is 1.0.)
  final double secondWaveSpeed;

  const WaterAnimation({
    super.key,
    this.width = 250,
    this.height = 200,
    // Primary wave defaults:
    this.amplitude = 20,
    this.frequency = 1,
    this.speed = 3,
    this.waterColor = Colors.blue,
    this.gradientColors,
    this.enableRipple = false,
    this.enableShader = false,
    // Secondary wave defaults:
    this.enableSecondWave = false,
    this.secondWaveColor = Colors.blueAccent,
    this.secondWaveAmplitude = 10.0,
    this.secondWaveFrequency = 1.5,
    this.secondWaveSpeed = 1.0,
  });

  @override
  WaterAnimationState createState() => WaterAnimationState();
}

/// A helper model representing a ripple effect on the water.
class Ripple {
  /// The position where the ripple was triggered.
  final Offset position;

  /// The time (in seconds) when the ripple started.
  final double startTime;

  Ripple({required this.position, required this.startTime});
}

class WaterAnimationState extends State<WaterAnimation>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  double _offset1 = 0.0; // Primary wave horizontal offset.
  double _offset2 = 0.0; // Secondary wave horizontal offset.
  double _elapsedSeconds = 0.0;
  final List<Ripple> _ripples = []; // Made final.
  final double _rippleDuration =
      1.0; // Duration for which a ripple is visible (in seconds).

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      double currentTime = elapsed.inMicroseconds / 1e6;
      double delta = currentTime - _elapsedSeconds;
      _elapsedSeconds = currentTime;
      setState(() {
        _offset1 += widget.speed * delta;
        if (widget.enableSecondWave) {
          _offset2 += widget.secondWaveSpeed * delta;
        }
        // Remove expired ripple effects.
        _ripples.removeWhere(
          (r) => (_elapsedSeconds - r.startTime) > _rippleDuration,
        );
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// Handles tap events to trigger a ripple effect.
  void _handleTap(TapUpDetails details) {
    if (!widget.enableRipple) return;
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPos = box.globalToLocal(details.globalPosition);
    setState(() {
      _ripples.add(Ripple(position: localPos, startTime: _elapsedSeconds));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget waterWidget = GestureDetector(
      onTapUp: widget.enableRipple ? _handleTap : null,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: WaterPainter(
            amplitude: widget.amplitude,
            frequency: widget.frequency,
            waterColor: widget.waterColor,
            gradientColors: widget.gradientColors,
            offset1: _offset1,
            enableSecondWave: widget.enableSecondWave,
            secondWaveColor: widget.secondWaveColor,
            secondWaveAmplitude: widget.secondWaveAmplitude,
            secondWaveFrequency: widget.secondWaveFrequency,
            offset2: _offset2,
            ripples: _ripples,
            rippleDuration: _rippleDuration,
            currentTime: _elapsedSeconds,
          ),
          child: Container(),
        ),
      ),
    );

    if (widget.enableShader) {
      waterWidget = ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        blendMode: BlendMode.modulate,
        child: waterWidget,
      );
    }
    return waterWidget;
  }
}

/// A CustomPainter that draws the water animation.
class WaterPainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final double offset1;
  final Color waterColor;
  final List<Color>? gradientColors;

  final bool enableSecondWave;
  final Color secondWaveColor;
  final double secondWaveAmplitude;
  final double secondWaveFrequency;
  final double offset2;

  final List<Ripple> ripples;
  final double rippleDuration;
  final double currentTime;

  WaterPainter({
    required this.amplitude,
    required this.frequency,
    required this.offset1,
    required this.waterColor,
    required this.gradientColors,
    required this.enableSecondWave,
    required this.secondWaveColor,
    required this.secondWaveAmplitude,
    required this.secondWaveFrequency,
    required this.offset2,
    required this.ripples,
    required this.rippleDuration,
    required this.currentTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Water surface level is set to 30% of the widget's height.
    double waterSurface = size.height * 0.3;

    // Draw the secondary wave in the background if enabled.
    if (enableSecondWave) {
      _drawWave(
        canvas: canvas,
        size: size,
        waterSurface: waterSurface,
        amplitude: secondWaveAmplitude,
        frequency: secondWaveFrequency,
        offset: offset2,
        color: secondWaveColor,
      );
    }

    // Draw the primary wave.
    _drawWave(
      canvas: canvas,
      size: size,
      waterSurface: waterSurface,
      amplitude: amplitude,
      frequency: frequency,
      offset: offset1,
      color: waterColor,
      gradientColors: gradientColors,
    );

    // Draw ripple effects.
    for (var ripple in ripples) {
      double progress = (currentTime - ripple.startTime) / rippleDuration;
      if (progress > 1) continue;
      double rippleRadius = progress * size.width / 3;
      int alpha = (255 * (1 - progress)).round();
      Paint ripplePaint =
          Paint()
            ..color = Colors.white.withAlpha(alpha)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0;
      canvas.drawCircle(ripple.position, rippleRadius, ripplePaint);
    }
  }

  void _drawWave({
    required Canvas canvas,
    required Size size,
    required double waterSurface,
    required double amplitude,
    required double frequency,
    required double offset,
    required Color color,
    List<Color>? gradientColors,
  }) {
    Path path = Path();
    path.moveTo(0, waterSurface);
    double waveLength = size.width / frequency;
    for (double x = 0; x <= size.width; x++) {
      double y =
          waterSurface +
          amplitude * math.sin((2 * math.pi / waveLength) * x - offset);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    Paint paint = Paint()..style = PaintingStyle.fill;
    if (gradientColors != null && gradientColors.length >= 2) {
      paint.shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, waterSurface, size.width, size.height - waterSurface),
      );
    } else {
      paint.color = color;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaterPainter oldDelegate) => true;
}

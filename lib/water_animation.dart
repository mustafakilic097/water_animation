library water_animation;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that displays a water animation effect with customizable parameters.
///
/// This widget simulates water using animated waves and supports the following features:
/// - A primary wave with configurable amplitude, frequency, and speed.
/// - Optional linear gradient fill for the water surface.
/// - Optional ripple effect when the water is tapped.
/// - An optional secondary wave layer with separate parameters.
/// - Customizable width and height.
///
/// **Usage Example:**
/// ```dart
/// WaterAnimation(
///   width: 250, // Widget width
///   height: 200, // Widget height
///   amplitude: 20, // Primary wave amplitude
///   frequency: 1, // Primary wave frequency
///   speed: 3, // Primary wave speed
///   waterColor: Colors.blue, // Primary wave color
///   gradientColors: [Colors.blue, Colors.lightBlueAccent], // Optional gradient fill
///   enableRipple: false, // Disable ripple effect by default
///   enableShader: false, // Disable shader effect (reserved for future use)
///   enableSecondWave: false, // Disable secondary wave by default
///   secondWaveColor: Colors.blueAccent, // Secondary wave color
///   secondWaveAmplitude: 10.0, // Secondary wave amplitude
///   secondWaveFrequency: 1.5, // Secondary wave frequency
///   secondWaveSpeed: 1.0, // Secondary wave speed
/// )
/// ```
class WaterAnimation extends StatefulWidget {
  /// The width of the widget. (Default is 250.)
  final double width;

  /// The height of the widget. (Default is 200.)
  final double height;

  /// The amplitude of the primary wave. (Default is 20.)
  final double amplitude;

  /// The frequency of the primary wave, representing the number of complete waves across the width. (Default is 1.)
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
    Key? key,
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
  }) : super(key: key);

  @override
  _WaterAnimationState createState() => _WaterAnimationState();
}

/// A helper model representing a ripple effect on the water.
class _Ripple {
  /// The position where the ripple was triggered.
  final Offset position;
  /// The time (in seconds) when the ripple started.
  final double startTime;
  _Ripple({required this.position, required this.startTime});
}

class _WaterAnimationState extends State<WaterAnimation>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  double _offset1 = 0.0; // Primary wave horizontal offset.
  double _offset2 = 0.0; // Secondary wave horizontal offset.
  double _elapsedSeconds = 0.0;
  List<_Ripple> _ripples = [];
  final double _rippleDuration = 1.0; // Duration for which a ripple is visible (in seconds).

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
        // Remove ripples that have exceeded their duration.
        _ripples.removeWhere((r) => (_elapsedSeconds - r.startTime) > _rippleDuration);
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
      _ripples.add(_Ripple(position: localPos, startTime: _elapsedSeconds));
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
          painter: _WaterPainter(
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
          child: Container(), // Empty container to provide a painting area.
        ),
      ),
    );

    // If shader effects are enabled, wrap the widget with a ShaderMask.
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

class _WaterPainter extends CustomPainter {
  // Primary wave parameters.
  final double amplitude;
  final double frequency;
  final double offset1;
  final Color waterColor;
  final List<Color>? gradientColors;
  // Secondary wave parameters.
  final bool enableSecondWave;
  final Color secondWaveColor;
  final double secondWaveAmplitude;
  final double secondWaveFrequency;
  final double offset2;
  // Ripple effects.
  final List<_Ripple> ripples;
  final double rippleDuration;
  final double currentTime;

  _WaterPainter({
    required this.amplitude,
    required this.frequency,
    required this.offset1,
    required this.waterColor,
    required this.gradientColors,
    // Secondary wave:
    required this.enableSecondWave,
    required this.secondWaveColor,
    required this.secondWaveAmplitude,
    required this.secondWaveFrequency,
    required this.offset2,
    // Ripple effects:
    required this.ripples,
    required this.rippleDuration,
    required this.currentTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the water surface level as 30% of the widget's height.
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

    // Draw the ripple effects.
    for (var ripple in ripples) {
      double progress = (currentTime - ripple.startTime) / rippleDuration;
      if (progress > 1) continue;
      double rippleRadius = progress * size.width / 3;
      double opacity = (1 - progress).clamp(0.0, 1.0);
      Paint ripplePaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(ripple.position, rippleRadius, ripplePaint);
    }
  }

  /// Draws a single wave using a sine function.
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
    // Draw the wave line based on sine function.
    for (double x = 0; x <= size.width; x++) {
      double y = waterSurface + amplitude * math.sin((2 * math.pi / waveLength) * x - offset);
      path.lineTo(x, y);
    }
    // Close the path by drawing to the bottom of the widget.
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    Paint paint = Paint()..style = PaintingStyle.fill;
    // Apply gradient if provided; otherwise, use the solid color.
    if (gradientColors != null && gradientColors.length >= 2) {
      paint.shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, waterSurface, size.width, size.height - waterSurface));
    } else {
      paint.color = color;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaterPainter oldDelegate) => true;
}

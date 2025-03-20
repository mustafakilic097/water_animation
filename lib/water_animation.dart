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
/// - Customizable water fill level via [waterFillFraction].
/// - If [fillTransitionDuration] is non-zero, changes to [waterFillFraction]
///   are smoothly animated.
/// - An optional [decoration] for container styling (with clipping for rounded borders).
/// - An optional [realisticWave] mode that creates a more natural wave shape.
/// - A new [onTap] callback that is triggered when the water is tapped.
class WaterAnimation extends StatefulWidget {
  final double width;
  final double height;

  /// A value in the range [0..1].
  /// - 0.0 means no water is drawn.
  /// - 1.0 means the water fills the entire container.
  final double waterFillFraction;

  /// If this duration is non-zero, changes to [waterFillFraction] will animate
  /// from the old value to the new value over this duration.
  final Duration fillTransitionDuration;

  /// The curve used when animating [waterFillFraction].
  final Curve fillTransitionCurve;

  /// Primary wave parameters.
  final double amplitude;
  final double frequency;
  final double speed;
  final Color waterColor;
  final List<Color>? gradientColors;

  /// Enables a ripple effect on tap.
  final bool enableRipple;

  /// Enables a shader effect (reserved for advanced usage).
  final bool enableShader;

  /// Secondary wave parameters.
  final bool enableSecondWave;
  final Color secondWaveColor;
  final double secondWaveAmplitude;
  final double secondWaveFrequency;
  final double secondWaveSpeed;

  /// If true, uses a combination of sine waves to create a more natural wave shape.
  final bool realisticWave;

  /// Decoration for the outer container. If it's a [BoxDecoration] with [borderRadius],
  /// the water animation is clipped to the rounded corners.
  final Decoration? decoration;

  /// Callback that is triggered when the water widget is tapped.
  final VoidCallback? onTap;

  const WaterAnimation({
    super.key,
    this.width = 250,
    this.height = 200,
    this.waterFillFraction = 0.5,
    this.fillTransitionDuration = Duration.zero,
    this.fillTransitionCurve = Curves.linear,
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
    // Realistic wave mode:
    this.realisticWave = false,
    this.decoration,
    this.onTap, // Yeni onTap özelliği eklendi.
  });

  @override
  WaterAnimationState createState() => WaterAnimationState();
}

/// Represents a ripple effect on the water.
class Ripple {
  final Offset position;
  final double startTime;

  Ripple({required this.position, required this.startTime});
}

class WaterAnimationState extends State<WaterAnimation>
    with TickerProviderStateMixin {
  /// A ticker for animating the wave offsets (for the wave motion).
  late final Ticker _waveTicker;

  /// An animation controller for animating the waterFillFraction changes.
  AnimationController? _fillController;
  Animation<double>? _fillAnimation;

  /// Current water fill fraction used by the painter.
  double _currentFillFraction = 0.0;

  double _offset1 = 0.0;
  double _offset2 = 0.0;
  double _elapsedSeconds = 0.0;

  final List<Ripple> _ripples = [];
  final double _rippleDuration = 1.0;

  @override
  void initState() {
    super.initState();

    _currentFillFraction = widget.waterFillFraction;

    // Wave ticker: animates the wave offsets.
    _waveTicker = createTicker((elapsed) {
      final currentTime = elapsed.inMicroseconds / 1e6;
      final delta = currentTime - _elapsedSeconds;
      _elapsedSeconds = currentTime;
      setState(() {
        _offset1 += widget.speed * delta;
        if (widget.enableSecondWave) {
          _offset2 += widget.secondWaveSpeed * delta;
        }
        _ripples.removeWhere(
          (r) => (_elapsedSeconds - r.startTime) > _rippleDuration,
        );
      });
    });
    _waveTicker.start();

    // If user wants animated fill transitions, create a controller.
    if (widget.fillTransitionDuration > Duration.zero) {
      _fillController = AnimationController(
        vsync: this,
        duration: widget.fillTransitionDuration,
      );
      _fillAnimation = Tween<double>(
        begin: _currentFillFraction,
        end: _currentFillFraction,
      ).animate(
        CurvedAnimation(
          parent: _fillController!,
          curve: widget.fillTransitionCurve,
        ),
      )..addListener(() {
        setState(() {
          _currentFillFraction = _fillAnimation!.value;
        });
      });
    }
  }

  @override
  void dispose() {
    _waveTicker.dispose();
    _fillController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WaterAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if waterFillFraction changed
    if (widget.waterFillFraction != oldWidget.waterFillFraction) {
      // If there's no fill transition duration, update immediately.
      if (widget.fillTransitionDuration == Duration.zero) {
        setState(() {
          _currentFillFraction = widget.waterFillFraction;
        });
      } else {
        // Animate from old fill to new fill
        _fillController?.duration = widget.fillTransitionDuration;
        _fillAnimation = Tween<double>(
          begin: _currentFillFraction,
          end: widget.waterFillFraction,
        ).animate(
          CurvedAnimation(
            parent: _fillController!,
            curve: widget.fillTransitionCurve,
          ),
        );
        _fillController?.forward(from: 0.0);
      }
    }
  }

  void _handleTap(TapUpDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final localPos = box.globalToLocal(details.globalPosition);
    // Ripple efekti ekle (eğer aktifse)
    if (widget.enableRipple) {
      setState(() {
        _ripples.add(Ripple(position: localPos, startTime: _elapsedSeconds));
      });
    }
    // Yeni onTap callback'i tetikle
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    // The painter uses _currentFillFraction to draw the water level.
    Widget waterWidget = GestureDetector(
      onTapUp: _handleTap,
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
            waterFillFraction: _currentFillFraction,
            realisticWave: widget.realisticWave,
          ),
        ),
      ),
    );

    if (widget.decoration != null) {
      // If the decoration is a BoxDecoration with a borderRadius, clip accordingly.
      if (widget.decoration is BoxDecoration) {
        final boxDeco = widget.decoration as BoxDecoration;
        final borderRadius = boxDeco.borderRadius;
        if (borderRadius != null) {
          waterWidget = ClipRRect(
            borderRadius: borderRadius,
            child: Container(decoration: boxDeco, child: waterWidget),
          );
        } else {
          waterWidget = Container(decoration: boxDeco, child: waterWidget);
        }
      } else {
        waterWidget = Container(
          decoration: widget.decoration,
          child: waterWidget,
        );
      }
    }

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

/// Paints the water waves, gradient fill, and ripple effects.
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

  /// [waterFillFraction] in [0..1].
  /// 0 => no water, 1 => fills entire container.
  final double waterFillFraction;

  /// If true, a second sine wave is added to create a more realistic shape.
  final bool realisticWave;

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
    required this.waterFillFraction,
    required this.realisticWave,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fraction = waterFillFraction.clamp(0.0, 1.0);
    if (fraction == 0.0) return;

    // Water surface is at height*(1 - fraction)
    final waterSurface = size.height * (1 - fraction);

    // Secondary wave behind the primary wave
    if (enableSecondWave) {
      _drawWave(
        canvas: canvas,
        size: size,
        waterSurface: waterSurface,
        amplitude: secondWaveAmplitude,
        frequency: secondWaveFrequency,
        offset: offset2,
        color: secondWaveColor,
        gradientColors: null,
        realisticWave: realisticWave,
      );
    }

    // Primary wave
    _drawWave(
      canvas: canvas,
      size: size,
      waterSurface: waterSurface,
      amplitude: amplitude,
      frequency: frequency,
      offset: offset1,
      color: waterColor,
      gradientColors: gradientColors,
      realisticWave: realisticWave,
    );

    // Ripples
    for (final ripple in ripples) {
      final progress = (currentTime - ripple.startTime) / rippleDuration;
      if (progress > 1) continue;
      final rippleRadius = progress * size.width / 3;
      final alpha = (255 * (1 - progress)).round();
      final ripplePaint =
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
    required bool realisticWave,
  }) {
    final path = Path();
    path.moveTo(0, waterSurface);
    final waveLength = size.width / frequency;

    for (double x = 0; x <= size.width; x++) {
      final baseWave =
          amplitude * math.sin((2 * math.pi / waveLength) * x - offset);
      double y = waterSurface + baseWave;
      if (realisticWave) {
        // Additional smaller wave for more natural shape
        final secondaryWave =
            0.2 *
            amplitude *
            math.sin((4 * math.pi / waveLength) * x - offset * 1.2);
        y += secondaryWave;
      }
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()..style = PaintingStyle.fill;
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

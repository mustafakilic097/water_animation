import 'package:flutter/material.dart';
import 'package:water_animation/water_animation.dart';

void main() {
  runApp(MaterialApp(home: const WaterAnimationDemo()));
}

class WaterAnimationDemo extends StatefulWidget {
  const WaterAnimationDemo({super.key});

  @override
  WaterAnimationDemoState createState() => WaterAnimationDemoState();
}

class WaterAnimationDemoState extends State<WaterAnimationDemo> {
  double amplitude = 20.0;
  double frequency = 1.0;
  double speed = 3.0;
  Color waterColor = Colors.blue;
  bool enableGradient = false;
  bool enableRipple = false;
  bool enableShader = false;
  bool enableSecondWave = false;
  double secondWaveAmplitude = 10.0;
  double secondWaveFrequency = 1.5;
  double secondWaveSpeed = 1.0;
  Color secondWaveColor = Colors.blueAccent;
  List<Color> gradientColors = [Colors.blue, Colors.lightBlueAccent];
  double waterFillFraction = 0.5;
  double fillTransitionDurationSeconds = 1.0;
  Curve fillTransitionCurve = Curves.easeInOut;
  bool realisticWave = false;
  bool enableDecoration = false;

  @override
  Widget build(BuildContext context) {
    final waterAnim = WaterAnimation(
      width: MediaQuery.of(context).size.width,
      height: 200,
      waterFillFraction: waterFillFraction,
      fillTransitionDuration: Duration(
        seconds: fillTransitionDurationSeconds.toInt(),
      ),
      fillTransitionCurve: fillTransitionCurve,
      amplitude: amplitude,
      frequency: frequency,
      speed: speed,
      waterColor: waterColor,
      gradientColors: enableGradient ? gradientColors : null,
      enableRipple: enableRipple,
      enableShader: enableShader,
      enableSecondWave: enableSecondWave,
      secondWaveAmplitude: secondWaveAmplitude,
      secondWaveFrequency: secondWaveFrequency,
      secondWaveSpeed: secondWaveSpeed,
      secondWaveColor: secondWaveColor,
      realisticWave: realisticWave,
      decoration:
          enableDecoration
              ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              )
              : null,
      onTap: () {
        debugPrint("Water widget tapped!");
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Water Animation Demo")),
      body: Column(
        children: [
          Expanded(child: Center(child: waterAnim)),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: WaterAnimationControlPanel(
                amplitude: amplitude,
                frequency: frequency,
                speed: speed,
                waterColor: waterColor,
                enableGradient: enableGradient,
                enableRipple: enableRipple,
                enableShader: enableShader,
                enableSecondWave: enableSecondWave,
                secondWaveAmplitude: secondWaveAmplitude,
                secondWaveFrequency: secondWaveFrequency,
                secondWaveSpeed: secondWaveSpeed,
                secondWaveColor: secondWaveColor,
                waterFillFraction: waterFillFraction,
                fillTransitionDurationSeconds: fillTransitionDurationSeconds,
                fillTransitionCurve: fillTransitionCurve,
                realisticWave: realisticWave,
                enableDecoration: enableDecoration,
                onParametersChanged: (
                  newAmplitude,
                  newFrequency,
                  newSpeed,
                  newWaterColor,
                  newEnableGradient,
                  newEnableRipple,
                  newEnableShader,
                  newEnableSecondWave,
                  newSecondWaveAmplitude,
                  newSecondWaveFrequency,
                  newSecondWaveSpeed,
                  newSecondWaveColor,
                  newWaterFillFraction,
                  newFillTransitionDurationSeconds,
                  newFillTransitionCurve,
                  newRealisticWave,
                  newEnableDecoration,
                ) {
                  setState(() {
                    amplitude = newAmplitude;
                    frequency = newFrequency;
                    speed = newSpeed;
                    waterColor = newWaterColor;
                    enableGradient = newEnableGradient;
                    enableRipple = newEnableRipple;
                    enableShader = newEnableShader;
                    enableSecondWave = newEnableSecondWave;
                    secondWaveAmplitude = newSecondWaveAmplitude;
                    secondWaveFrequency = newSecondWaveFrequency;
                    secondWaveSpeed = newSecondWaveSpeed;
                    secondWaveColor = newSecondWaveColor;
                    waterFillFraction = newWaterFillFraction;
                    fillTransitionDurationSeconds =
                        newFillTransitionDurationSeconds;
                    fillTransitionCurve = newFillTransitionCurve;
                    realisticWave = newRealisticWave;
                    enableDecoration = newEnableDecoration;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterAnimationControlPanel extends StatefulWidget {
  final double amplitude;
  final double frequency;
  final double speed;
  final Color waterColor;
  final bool enableGradient;
  final bool enableRipple;
  final bool enableShader;
  final bool enableSecondWave;
  final double secondWaveAmplitude;
  final double secondWaveFrequency;
  final double secondWaveSpeed;
  final Color secondWaveColor;

  // Yeni parametreler:
  final double waterFillFraction;
  final double fillTransitionDurationSeconds;
  final Curve fillTransitionCurve;
  final bool realisticWave;
  final bool enableDecoration;

  final Function(
    double amplitude,
    double frequency,
    double speed,
    Color waterColor,
    bool enableGradient,
    bool enableRipple,
    bool enableShader,
    bool enableSecondWave,
    double secondWaveAmplitude,
    double secondWaveFrequency,
    double secondWaveSpeed,
    Color secondWaveColor,
    double waterFillFraction,
    double fillTransitionDurationSeconds,
    Curve fillTransitionCurve,
    bool realisticWave,
    bool enableDecoration,
  )
  onParametersChanged;

  const WaterAnimationControlPanel({
    super.key,
    required this.amplitude,
    required this.frequency,
    required this.speed,
    required this.waterColor,
    required this.enableGradient,
    required this.enableRipple,
    required this.enableShader,
    required this.enableSecondWave,
    required this.secondWaveAmplitude,
    required this.secondWaveFrequency,
    required this.secondWaveSpeed,
    required this.secondWaveColor,
    required this.waterFillFraction,
    required this.fillTransitionDurationSeconds,
    required this.fillTransitionCurve,
    required this.realisticWave,
    required this.enableDecoration,
    required this.onParametersChanged,
  });

  @override
  WaterAnimationControlPanelState createState() =>
      WaterAnimationControlPanelState();
}

class WaterAnimationControlPanelState
    extends State<WaterAnimationControlPanel> {
  late double amplitude;
  late double frequency;
  late double speed;
  late Color waterColor;
  late bool enableGradient;
  late bool enableRipple;
  late bool enableShader;
  late bool enableSecondWave;
  late double secondWaveAmplitude;
  late double secondWaveFrequency;
  late double secondWaveSpeed;
  late Color secondWaveColor;

  // Yeni parametreler:
  late double waterFillFraction;
  late double fillTransitionDurationSeconds;
  late Curve fillTransitionCurve;
  late bool realisticWave;
  late bool enableDecoration;

  // Fill curve dropdown için:
  late String selectedCurve;

  @override
  void initState() {
    super.initState();
    amplitude = widget.amplitude;
    frequency = widget.frequency;
    speed = widget.speed;
    waterColor = widget.waterColor;
    enableGradient = widget.enableGradient;
    enableRipple = widget.enableRipple;
    enableShader = widget.enableShader;
    enableSecondWave = widget.enableSecondWave;
    secondWaveAmplitude = widget.secondWaveAmplitude;
    secondWaveFrequency = widget.secondWaveFrequency;
    secondWaveSpeed = widget.secondWaveSpeed;
    secondWaveColor = widget.secondWaveColor;

    waterFillFraction = widget.waterFillFraction;
    fillTransitionDurationSeconds = widget.fillTransitionDurationSeconds;
    fillTransitionCurve = widget.fillTransitionCurve;
    realisticWave = widget.realisticWave;
    enableDecoration = widget.enableDecoration;

    selectedCurve =
        (fillTransitionCurve == Curves.linear) ? "Linear" : "EaseInOut";
  }

  void _notify() {
    widget.onParametersChanged(
      amplitude,
      frequency,
      speed,
      waterColor,
      enableGradient,
      enableRipple,
      enableShader,
      enableSecondWave,
      secondWaveAmplitude,
      secondWaveFrequency,
      secondWaveSpeed,
      secondWaveColor,
      waterFillFraction,
      fillTransitionDurationSeconds,
      fillTransitionCurve,
      realisticWave,
      enableDecoration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            "Water Animation Controls",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Amplitude
          Row(
            children: [
              const Text("Amplitude"),
              Expanded(
                child: Slider(
                  value: amplitude,
                  min: 10,
                  max: 100,
                  divisions: 9,
                  label: amplitude.toStringAsFixed(0),
                  onChanged: (val) {
                    setState(() {
                      amplitude = val;
                      _notify();
                    });
                  },
                ),
              ),
            ],
          ),
          // Frequency
          Row(
            children: [
              const Text("Frequency"),
              Expanded(
                child: Slider(
                  value: frequency,
                  min: 0.5,
                  max: 3.0,
                  divisions: 10,
                  label: frequency.toStringAsFixed(1),
                  onChanged: (val) {
                    setState(() {
                      frequency = val;
                      _notify();
                    });
                  },
                ),
              ),
            ],
          ),
          // Speed
          Row(
            children: [
              const Text("Speed"),
              Expanded(
                child: Slider(
                  value: speed,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  label: speed.toStringAsFixed(1),
                  onChanged: (val) {
                    setState(() {
                      speed = val;
                      _notify();
                    });
                  },
                ),
              ),
            ],
          ),
          // Water Color
          Row(
            children: [
              const Text("Water Color: "),
              IconButton(
                icon: const Icon(Icons.circle, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    waterColor = Colors.blue;
                    _notify();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.circle, color: Colors.cyan),
                onPressed: () {
                  setState(() {
                    waterColor = Colors.cyan;
                    _notify();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.circle, color: Colors.indigo),
                onPressed: () {
                  setState(() {
                    waterColor = Colors.indigo;
                    _notify();
                  });
                },
              ),
            ],
          ),
          // Gradient, Ripple, Shader
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Gradient"),
              Switch(
                value: enableGradient,
                onChanged: (val) {
                  setState(() {
                    enableGradient = val;
                    _notify();
                  });
                },
              ),
              const Text("Ripple"),
              Switch(
                value: enableRipple,
                onChanged: (val) {
                  setState(() {
                    enableRipple = val;
                    _notify();
                  });
                },
              ),
              const Text("Shader"),
              Switch(
                value: enableShader,
                onChanged: (val) {
                  setState(() {
                    enableShader = val;
                    _notify();
                  });
                },
              ),
            ],
          ),
          // Yeni: Water Fill Fraction
          Row(
            children: [
              const Text("Fill Fraction"),
              Expanded(
                child: Slider(
                  value: waterFillFraction,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: waterFillFraction.toStringAsFixed(2),
                  onChanged: (val) {
                    setState(() {
                      waterFillFraction = val;
                      _notify();
                    });
                  },
                ),
              ),
            ],
          ),
          // Yeni: Fill Transition Duration
          Row(
            children: [
              const Text("Fill Duration (s)"),
              Expanded(
                child: Slider(
                  value: fillTransitionDurationSeconds,
                  min: 0.0,
                  max: 3.0,
                  divisions: 6,
                  label: fillTransitionDurationSeconds.toStringAsFixed(1),
                  onChanged: (val) {
                    setState(() {
                      fillTransitionDurationSeconds = val;
                      _notify();
                    });
                  },
                ),
              ),
            ],
          ),
          // Yeni: Fill Transition Curve
          Row(
            children: [
              const Text("Fill Curve"),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedCurve,
                items:
                    <String>["Linear", "EaseInOut"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCurve = val!;
                    fillTransitionCurve =
                        (selectedCurve == "Linear")
                            ? Curves.linear
                            : Curves.easeInOut;
                    _notify();
                  });
                },
              ),
            ],
          ),
          // Yeni: Realistic Wave
          Row(
            children: [
              const Text("Realistic Wave"),
              Switch(
                value: realisticWave,
                onChanged: (val) {
                  setState(() {
                    realisticWave = val;
                    _notify();
                  });
                },
              ),
            ],
          ),
          // Yeni: Decoration
          Row(
            children: [
              const Text("Decoration"),
              Switch(
                value: enableDecoration,
                onChanged: (val) {
                  setState(() {
                    enableDecoration = val;
                    _notify();
                  });
                },
              ),
            ],
          ),
          const Divider(),
          // İkinci Dalga Kontrolleri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Enable 2nd Wave"),
              Switch(
                value: enableSecondWave,
                onChanged: (val) {
                  setState(() {
                    enableSecondWave = val;
                    _notify();
                  });
                },
              ),
            ],
          ),
          if (enableSecondWave) ...[
            Row(
              children: [
                const Text("2nd Amplitude"),
                Expanded(
                  child: Slider(
                    value: secondWaveAmplitude,
                    min: 5,
                    max: 100,
                    divisions: 9,
                    label: secondWaveAmplitude.toStringAsFixed(0),
                    onChanged: (val) {
                      setState(() {
                        secondWaveAmplitude = val;
                        _notify();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("2nd Frequency"),
                Expanded(
                  child: Slider(
                    value: secondWaveFrequency,
                    min: 0.5,
                    max: 3.0,
                    divisions: 10,
                    label: secondWaveFrequency.toStringAsFixed(1),
                    onChanged: (val) {
                      setState(() {
                        secondWaveFrequency = val;
                        _notify();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("2nd Speed"),
                Expanded(
                  child: Slider(
                    value: secondWaveSpeed,
                    min: 0.5,
                    max: 5.0,
                    divisions: 9,
                    label: secondWaveSpeed.toStringAsFixed(1),
                    onChanged: (val) {
                      setState(() {
                        secondWaveSpeed = val;
                        _notify();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("2nd Color: "),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      secondWaveColor = Colors.blueAccent;
                      _notify();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.purple),
                  onPressed: () {
                    setState(() {
                      secondWaveColor = Colors.purple;
                      _notify();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.circle, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      secondWaveColor = Colors.green;
                      _notify();
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

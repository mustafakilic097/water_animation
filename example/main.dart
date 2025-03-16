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

  @override
  Widget build(BuildContext context) {
    final waterAnim = WaterAnimation(
      width: MediaQuery.of(context).size.width,
      height: 200,
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
          const Divider(),
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

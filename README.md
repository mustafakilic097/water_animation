<img src="https://github.com/user-attachments/assets/29507311-77b6-4772-aa6c-dd0749638c88" alt="WATER-ANİMATİON" width="300">

# Water Animation
A simple Flutter package that provides a customizable water animation widget to create realistic water effects with animated waves, gradient fills, and interactive ripple effects.

![Water Animation](https://github.com/user-attachments/assets/af82e587-df10-4813-acd5-104b3c28a68f)

## Features

- **Animated Waves:** Simulate dynamic water surfaces with smooth, animated waves.
- **Customizable Water Level:** Control the water fill level via the `waterFillFraction` parameter.
- **Animated Fill Transition:** Smoothly animate changes in water level using `fillTransitionDuration` and `fillTransitionCurve`.
- **Customizable Appearance:** Adjust wave amplitude, frequency, speed, water color, and gradient fills to match your design.
- **Secondary Wave:** Optionally add a secondary wave layer for extra visual depth.
- **Realistic Wave Mode:** Enable `realisticWave` to generate a more natural, complex wave shape.
- **Ripple Effects & Tap Interactions:** Trigger ripple effects on tap and handle custom tap events with the `onTap` callback.
- **Decorative Container:** Style the water animation with the `decoration` parameter, supporting features like rounded borders through clipping.
- **Easy Integration:** Designed for quick and hassle-free integration into your existing Flutter projects.

## Getting Started

1. **Add Dependency:**  
   Add `water_animation` to your project's `pubspec.yaml` file:

   ```yaml
   dependencies:
     water_animation: ^0.0.3
   ```

2. **Install the Package:**  
   Run the following command in your terminal:
   
   ```bash
   flutter pub get
   ```

## Usage

Import the package in your Dart file and use the `WaterAnimation` widget. For example:

```dart
import 'package:flutter/material.dart';
import 'package:water_animation/water_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Animation Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Water Animation Demo')),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: WaterAnimation(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  waterFillFraction: 0.5, // 50% fill level
                  fillTransitionDuration: Duration(seconds: 1),
                  fillTransitionCurve: Curves.easeInOut,
                  amplitude: 20,
                  frequency: 1,
                  speed: 3,
                  waterColor: Colors.blue,
                  gradientColors: [Colors.blue, Colors.lightBlueAccent],
                  enableRipple: true,
                  enableShader: false,
                  enableSecondWave: true,
                  secondWaveColor: Colors.blueAccent,
                  secondWaveAmplitude: 10.0,
                  secondWaveFrequency: 1.5,
                  secondWaveSpeed: 1.0,
                  realisticWave: true,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    print('Water tapped!');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Additional Information

- **Repository:**  
  For more details, to contribute, or to file issues, please visit the [GitHub repository](https://github.com/mustafakilic097/water_animation).

- **Contributing:**  
  Contributions are welcome! Feel free to open issues or submit pull requests with improvements.

- **License:**  
  This package is released under the MIT License. See the [LICENSE](LICENSE) file for details.

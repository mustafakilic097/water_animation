# Water Animation

A simple Flutter package that provides a customizable water animation widget to create realistic water effects with animated waves, gradient fills, and ripple effects.

![Water Animation](https://github.com/user-attachments/assets/af82e587-df10-4813-acd5-104b3c28a68f)

## Features

- **Animated Waves:** Simulate dynamic water surfaces with smooth, animated waves.
- **Customizable:** Easily adjust wave amplitude, frequency, speed, water color, and gradient fills.
- **Secondary Wave:** Optionally add a secondary wave layer for extra visual depth.
- **Ripple Effects:** Trigger ripple effects on tap for interactive water surface effects.
- **Easy Integration:** Designed for quick integration into your existing Flutter projects.

## Getting Started

1. **Add Dependency:**  
   Add `water_animation` to your project's `pubspec.yaml` file:

   ```yaml
   dependencies:
     water_animation: ^0.0.1
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
                  amplitude: 20,
                  frequency: 1,
                  speed: 3,
                  waterColor: Colors.blue,
                  gradientColors: [Colors.blue, Colors.lightBlueAccent],
                  enableRipple: false,
                  enableShader: false,
                  enableSecondWave: false,
                  secondWaveColor: Colors.blueAccent,
                  secondWaveAmplitude: 10.0,
                  secondWaveFrequency: 1.5,
                  secondWaveSpeed: 1.0,
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
  For more details, to contribute, or to file issues, please visit the [GitHub repository](https://github.com/yourusername/your-repo).

- **Contributing:**  
  Contributions are welcome! Feel free to open issues or submit pull requests with improvements.

- **License:**  
  This package is released under the MIT License. See the [LICENSE](LICENSE) file for details.

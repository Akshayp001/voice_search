
# voice\_search

A Flutter package that provides a customizable voice recognition widget for performing voice searches in multiple languages. This package supports various platforms including web, Android, iOS, macOS, Windows, and Linux.

## Features

* **Voice Recognition**: Perform voice searches with ease.
* **Customizable**: Adjust colors, icons, sizes, and animations to fit your app's design.
* **Multilingual**: Supports different languages for voice recognition.
* **Platform Support**: Works on web, Android, iOS, macOS, Windows, and Linux.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  voice_search: ^0.0.1
```

## Usage

Import the package in your Dart file:

```dart
import 'package:voice_search/voice_search.dart';
```

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:voice_search/voice_search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Voice Search Example')),
        body: Center(
          child: VoiceSearchWidget(
            onResult: (result) {
              print('Voice Search Result: $result');
            },
          ),
        ),
      ),
    );
  }
}
```

### Customization

You can customize the `VoiceSearchWidget` by passing different parameters:

```dart
VoiceSearchWidget(
  localeCode: 'es_ES', // Set locale for voice recognition
  activeWidgetColor: Colors.green, // Color when widget is active
  inactiveWidgetColor: Colors.red, // Color when widget is inactive
  activeIcon: Icons.mic, // Icon when widget is active
  inactiveIcon: Icons.mic_none, // Icon when widget is inactive
  maxRadius: 40, // Maximum radius of the widget
  minRadius: 20, // Minimum radius of the widget
  animationDuration: Duration(milliseconds: 500), // Animation duration
  animationCurve: Curves.bounceIn, // Animation curve
  onResult: (result) {
    print('Voice Search Result: $result');
  },
  onListeningStarted: () {
    print('Listening started');
  },
  onListeningStopped: () {
    print('Listening stopped');
  },
);
```

## Permissions

### Android

Add the following permissions to your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
```

## Android SDK 30 or later

If you are targeting Android SDK, i.e. you set your `targetSDKVersion` to 30 or later, then you will need to add the following to your `AndroidManifest.xml` right after the permissions section. See the example app for the complete usage.

```xml
<queries>
    <intent>
        <action android:name="android.speech.RecognitionService" />
    </intent>
</queries>
```

### iOS

Add the following permissions to your `Info.plist` file:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for voice search.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>We need access to speech recognition for voice search.</string>
```

## Supported Platforms

* Web
* Android
* iOS
* macOS
* Windows
* Linux

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Acknowledgements

This package uses the `speech_to_text` package for speech recognition.



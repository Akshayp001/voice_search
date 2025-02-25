/// This file contains the [VoiceSearchService] class, which provides
/// voice recognition functionality using the [speech_to_text] package.
///
/// The [VoiceSearchService] class encapsulates the initialization of the speech
/// recognition engine, starting/stopping listening, handling locale changes,
/// and returning recognized words.
library;

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// A service that handles voice search functionality using the speech_to_text package.
///
/// It initializes the speech recognition engine, listens for speech input,
/// and provides recognized words through callbacks.
class VoiceSearchService {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = "";
  String _localeId = "en_US";

  /// Constructs a [VoiceSearchService] instance and initializes the speech recognizer.
  VoiceSearchService() {
    _speech = stt.SpeechToText();
  }

  /// Initializes the speech recognition engine.
  ///
  /// This method attempts to initialize the speech recognition engine. If successful,
  /// it retrieves and prints the list of available locales. Otherwise, it prints an error
  /// message indicating that speech recognition has been denied.
  ///
  /// Returns a [Future] that completes when the initialization is finished.
  Future<void> init() async {
    bool available = await _speech.initialize(
      onStatus: (val) => debugPrint('onStatus: $val'),
      onError: (val) => debugPrint('onError: $val'),
    );
    if (available) {
      var locales = await _speech.locales();
      debugPrint(locales.toString());
    } else {
      debugPrint("The user has denied the use of speech recognition.");
    }
  }

  /// Starts listening for voice input.
  ///
  /// If the service is not already listening, this method starts the speech recognition
  /// engine and sets up a callback to return recognized words.
  ///
  /// Parameters:
  ///   - [onResult]: A function that accepts a [String] parameter. It is called with
  ///     the recognized words whenever they are available.
  void startListening({required Function(String) onResult}) {
    if (!_isListening) {
      _speech.listen(
        onResult: (val) {
          _lastWords = val.recognizedWords;
          onResult(_lastWords);
        },
        localeId: _localeId,
      );
      _isListening = true;
    }
  }

  /// Stops listening for voice input.
  ///
  /// If the service is currently listening, this method stops the speech recognition
  /// engine and updates the listening status.
  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  /// Changes the locale used for speech recognition.
  ///
  /// Parameters:
  ///   - [localeId]: A [String] representing the new locale identifier (e.g., "en_US").
  void changeLocale(String localeId) {
    _localeId = localeId;
  }

  /// Returns whether the service is currently listening for voice input.
  ///
  /// Returns:
  ///   A [bool] that is `true` if the service is listening, or `false` otherwise.
  bool get isListening => _isListening;

  /// Returns the last recognized words from the speech input.
  ///
  /// Returns:
  ///   A [String] containing the most recent recognized words.
  String get lastWords => _lastWords;
}


import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceSearchService {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = "";
  String _localeId = "en_US";

  VoiceSearchService() {
    _speech = stt.SpeechToText();
  }

  Future<void> init() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      var locales = await _speech.locales();
      print(locales);
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void startListening({required Function(String) onResult}) {
    if (!_isListening) {
      _speech.listen(
        onResult: (val) {
          _lastWords = val.recognizedWords;
          if (onResult != null) {
            onResult(_lastWords);
          }
        },
        localeId: _localeId,
      );
      _isListening = true;
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  void changeLocale(String localeId) {
    _localeId = localeId;
  }

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
}

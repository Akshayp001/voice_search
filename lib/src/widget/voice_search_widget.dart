import 'dart:math';
import 'package:flutter/material.dart';
import '../service/voice_service.dart';
// import 'package:audioplayers/audioplayers.dart';

/// A callback function type that is triggered when a voice search result is obtained.
/// The recognized speech text is passed as a parameter.
typedef VoiceSearchResultCallback = void Function(String result);

/// A customizable voice search widget that enables speech recognition.
///
/// This widget allows users to start and stop voice search by tapping on it.
/// It provides animation effects, customizable colors, icons, and optional event
/// callbacks for when listening starts or stops.
class VoiceSearchWidget extends StatefulWidget {
  /// The locale code for speech recognition (e.g., 'en_US' for English US).
  final String localeCode;

  /// Background color when the widget is active (listening).
  final Color activeWidgetColor;

  /// Background color when the widget is inactive (not listening).
  final Color inactiveWidgetColor;

  /// Icon displayed when the widget is active (listening).
  final IconData activeIcon;

  /// Icon displayed when the widget is inactive (not listening).
  final IconData inactiveIcon;

  /// Elevation of the widget (shadow effect).
  final double? elevation;

  /// Border color of the widget (optional).
  final Color? borderColor;

  /// Maximum radius of the animated widget.
  final double maxRadius;

  /// Minimum radius of the animated widget.
  final double minRadius;

  /// Duration of the animation transition.
  final Duration animationDuration;

  /// The curve for animation transitions.
  final Curve animationCurve;

  /// Callback function triggered when a voice search result is available.
  final VoiceSearchResultCallback? onResult;

  /// Callback function triggered when voice listening starts.
  final VoidCallback? onListeningStarted;

  /// Callback function triggered when voice listening stops.
  final VoidCallback? onListeningStopped;

  // final String? voiceSearchStartSoundPath;
  // final String? voiceSearchStopSoundPath;

  /// Creates a [VoiceSearchWidget] with the specified properties.
  const VoiceSearchWidget({
    super.key,
    this.localeCode = 'en_US',
    this.activeWidgetColor = Colors.amberAccent,
    this.inactiveWidgetColor = Colors.lightBlue,
    this.activeIcon = Icons.mic_off,
    this.inactiveIcon = Icons.mic,
    this.elevation,
    this.borderColor,
    this.maxRadius = 30,
    this.minRadius = 25,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    required this.onResult,
    this.onListeningStarted,
    this.onListeningStopped,
    // this.voiceSearchStartSoundPath,
    // this.voiceSearchStopSoundPath,
  });

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

/// The state class for [VoiceSearchWidget] that handles user interactions
/// and controls the speech recognition process.
class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with SingleTickerProviderStateMixin {
  /// Tracks whether the widget is currently listening for voice input.
  late bool _isListening;

  /// Instance of the voice search service.
  late VoiceSearchService _voiceSearchService;

  /// Animation controller for handling widget animations.
  late AnimationController _animationController;

  /// Animation for the widget's size transition.
  late Animation<double> _animation;

  // AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _isListening = false;
    _voiceSearchService = VoiceSearchService();
    _voiceSearchService.changeLocale(widget.localeCode);
    _voiceSearchService.init();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(begin: widget.minRadius, end: widget.maxRadius)
        .animate(CurvedAnimation(
            parent: _animationController, curve: widget.animationCurve));

    // _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    // _audioPlayer!.dispose();
  }

  // Future<void> _playSound(String? soundPath) async {
  //   if (soundPath != null) {
  //     await _audioPlayer?.play(AssetSource(soundPath));
  //   }
  // }

  /// Starts the voice listening process.
  void _startListening() async {
    // if (widget.voiceSearchStartSoundPath != null) {
    //   await _playSound(widget.voiceSearchStartSoundPath);
    // }
    setState(() {
      _isListening = true;
    });
    _animationController.forward();
    _voiceSearchService.startListening(onResult: (val) {
      if (widget.onResult != null) {
        widget.onResult!(val);
      }
    });
    if (widget.onListeningStarted != null) {
      widget.onListeningStarted!();
    }
  }

  /// Stops the voice listening process.
  void _stopListening() async {
    // if (widget.voiceSearchStopSoundPath != null) {
    //   await _playSound(widget.voiceSearchStopSoundPath);
    // }
    setState(() {
      _isListening = false;
    });
    _animationController.reverse();
    _voiceSearchService.stopListening();
    if (widget.onListeningStopped != null) {
      widget.onListeningStopped!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double sizeH = constraints.maxHeight;
      double sizeW = constraints.maxWidth;
      double miniSize = min(sizeW, sizeH);
      return GestureDetector(
        onTapDown: (_) => _startListening(),
        onTapUp: (_) => _stopListening(),
        onTapCancel: _stopListening,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Material(
              elevation: widget.elevation ?? 0,
              shape: CircleBorder(
                side: BorderSide(
                  color: widget.borderColor ?? Colors.transparent,
                  width: widget.borderColor != null ? 2 : 0,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: _isListening
                    ? widget.activeWidgetColor
                    : widget.inactiveWidgetColor,
                minRadius: widget.minRadius,
                maxRadius: widget.maxRadius,
                child: Center(
                  child: Icon(
                    _isListening ? widget.activeIcon : widget.inactiveIcon,
                    size: _animation.value > miniSize
                        ? miniSize * 0.7
                        : _animation.value,
                    shadows: const [
                      BoxShadow(
                          blurRadius: 15, spreadRadius: 30, color: Colors.black)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

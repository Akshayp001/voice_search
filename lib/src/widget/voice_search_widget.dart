import 'dart:math';

import 'package:flutter/material.dart';
import '../service/voice_service.dart';

typedef VoiceSearchResultCallback = void Function(String result);

class VoiceSearchWidget extends StatefulWidget {
  final String localeCode;
  final Color activeWidgetColor;
  final Color inactiveWidgetColor;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final double? elevation;
  final Color? borderColor;
  final double maxRadius;
  final double minRadius;
  final Duration animationDuration;
  final Curve animationCurve;
  final VoiceSearchResultCallback? onResult;
  final VoidCallback? onListeningStarted;
  final VoidCallback? onListeningStopped;

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
  });

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with SingleTickerProviderStateMixin {
  late bool _isListening;
  late VoiceSearchService _voiceSearchService;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
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

  void _stopListening() {
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

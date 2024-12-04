// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class FadingLetterDisplay extends StatefulWidget {
  final String letter;
  final Duration duration;

  const FadingLetterDisplay({
    super.key,
    required this.letter,
    this.duration = const Duration(milliseconds: 750),
  });

  @override
  State<FadingLetterDisplay> createState() => _FadingLetterDisplayState();
}

class _FadingLetterDisplayState extends State<FadingLetterDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve:Curves.linear,
    );
    _controller.forward(); // Play the animation when the widget is first built.
  }

  @override
  void didUpdateWidget(covariant FadingLetterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reset(); // Reset the animation.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        widget.letter.toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

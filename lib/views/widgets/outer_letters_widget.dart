// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:soletra_app/views/widgets/fading_letter_display.dart';

class OuterLettersWidget extends StatelessWidget {
  final List<String> letters;
  final Function(String) onTap;
  const OuterLettersWidget({
    super.key,
    required this.letters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 75;
    final double angleIncrement = (2 * math.pi) / letters.length;
    const double avatarRadius = 28;
    return Stack(
      alignment: Alignment.center,
      children: List.generate(letters.length, (index) {
        final angle = angleIncrement * index;
        final double dx = radius * math.cos(angle);
        final double dy = radius * math.sin(angle);

        return Positioned(
          left: ((MediaQuery.sizeOf(context).width * 0.5) - avatarRadius) + dx,
          top: ((MediaQuery.sizeOf(context).height * 0.15) - avatarRadius) + dy,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            radius: 4,
            onTap: () {
              onTap(letters[index]);
            },
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: const Color(0xFFE4E7EC),
              child: FadingLetterDisplay(letter: letters[index]),
            ),
          ),
        );
      }),
    );
  }
}

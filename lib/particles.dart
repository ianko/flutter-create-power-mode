import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

class CircleParticle extends Particle {
  CircleParticle({@required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    final rnd = Random(seed);

    if (progress > 0.5) {
      HapticFeedback.heavyImpact();
    }

    CompositeParticle(
      children: [
        RectangleMirror.builder(
          numberOfParticles: 1 + rnd.nextInt(3),
          initialDistance: 0.0,
          particleBuilder: (i) {
            return CircleMirror(
              numberOfParticles: 2,
              child: AnimatedPositionedParticle(
                begin: Offset(0.0, 5.0 * i),
                end: Offset(0.0, -5.0 * i),
                child: FourRandomSlotParticle(
                  relativeDistanceToMiddle: 1.0,
                  children: [
                    FadingCircle(color: color, radius: 1.0 + rnd.nextInt(4)),
                    FadingCircle(color: color, radius: 1.0 + rnd.nextInt(4)),
                    FadingCircle(color: color, radius: 1.0 + rnd.nextInt(4)),
                    FadingCircle(color: color, radius: 1.0 + rnd.nextInt(4)),
                  ],
                ),
              ),
            );
          },
        ),
        IntervalParticle(
          interval: Interval(0.5, 1.0),
          child: Firework(),
        ),
      ],
    ).paint(canvas, size, progress, seed);
  }
}

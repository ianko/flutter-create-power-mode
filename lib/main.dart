// Based/Inspired by: https://twitter.com/JoelBesada/status/670343885655293952
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import './particles.dart';
import './textfield.dart';

class PowerMode extends StatefulWidget {
  @override
  _PowerModeState createState() => _PowerModeState();
}

class _PowerModeState extends State<PowerMode> {
  AnimationController ctrl;
  Offset shake = Offset.zero;
  Rect pos = Rect.zero;

  Future<void> renderParticles(Rect r) async {
    final rnd = Random();
    final power = 2.0 + rnd.nextInt(5);
    final offs = Offset(
      power * (rnd.nextDouble() > 0.5 ? -1 : 1),
      power * (rnd.nextDouble() > 0.5 ? -1 : 1),
    );

    setState(() {
      pos = r;
      shake = offs;
      ctrl?.forward(from: 0.0);
    });

    await HapticFeedback.mediumImpact();

    // reset the offset
    await Future<void>.delayed(Duration(milliseconds: 100));
    setState(() => shake = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Transform.translate(
        offset: shake,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned(
                top: pos.top,
                left: pos.left,
                width: 20.0,
                height: 20.0,
                child: PimpedButton(
                  particle: CircleParticle(color: Theme.of(context).primaryColor),
                  pimpedWidgetBuilder: (context, controller) {
                    ctrl = controller;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: PowerTextField(onCaretChange: renderParticles),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(PowerMode());

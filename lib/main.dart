import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

void main() => runApp(PowerMode());

class PowerMode extends StatefulWidget {
  @override
  _PowerModeState createState() => _PowerModeState();
}

class _PowerModeState extends State<PowerMode> {
  AnimationController ctrl;
  Rect pos = Rect.zero;
  Offset shake = Offset.zero;

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
    await Future<void>.delayed(Duration(milliseconds: 300));
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

class PowerTextField extends StatefulWidget {
  const PowerTextField({this.cursorWidth = 2.0, this.onCaretChange});

  final double cursorWidth;
  final void Function(Rect) onCaretChange;

  @override
  _PowerTextFieldState createState() => _PowerTextFieldState();
}

const _kHint = 'Type something...';

class _PowerTextFieldState extends State<PowerTextField> {
  final key = GlobalKey();
  final node = FocusNode();
  final ctrl = TextEditingController(text: _kHint);

  void onChange(String str) {
    if (str.isEmpty) {
      return;
    }

    final EditableTextState s = key.currentState;
    final re = s.renderEditable;
    final pos = TextPosition(offset: re.selection.baseOffset);
    final anc = key.currentContext.ancestorRenderObjectOfType(const TypeMatcher<Scaffold>());
    final local = re.getLocalRectForCaret(pos);
    final global = re.localToGlobal(Offset(widget.cursorWidth, 0.0), ancestor: anc);

    widget.onCaretChange(local.translate(global.dx, global.dy));
  }

  void clearHintText() {
    if (node.hasFocus && ctrl.text == _kHint) {
      ctrl.clear();
    } else if (!node.hasFocus && ctrl.text.isEmpty) {
      ctrl.text = _kHint;
    }
  }

  @override
  void initState() {
    super.initState();
    node.addListener(clearHintText);
  }

  @override
  void dispose() {
    node.dispose();
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color(0x0A000000),
        border: Border(bottom: BorderSide(color: theme.primaryColor)),
      ),
      child: EditableText(
        key: key,
        focusNode: node,
        controller: ctrl,
        onChanged: onChange,
        cursorWidth: widget.cursorWidth,
        paintCursorAboveText: true,
        style: theme.textTheme.subhead,
        cursorColor: theme.primaryColor,
        backgroundCursorColor: theme.disabledColor,
      ),
    );
  }
}

class CircleParticle extends Particle {
  CircleParticle({@required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    final rnd = Random(seed);

    Particle circle() => FadingCircle(color: color, radius: 1.0 + rnd.nextInt(4));

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
                  children: [circle(), circle(), circle(), circle()],
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

    // fireworks
    if (progress > 0.5) {
      HapticFeedback.heavyImpact();
    }
  }
}

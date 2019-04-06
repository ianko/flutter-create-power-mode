import 'package:flutter/material.dart';

class PowerTextField extends StatefulWidget {
  const PowerTextField({this.cursorWidth = 2.0, this.onCaretChange});

  final double cursorWidth;
  final void Function(Rect) onCaretChange;

  @override
  _PowerTextFieldState createState() => _PowerTextFieldState();
}

class _PowerTextFieldState extends State<PowerTextField> {
  final key = GlobalKey();
  final node = FocusNode();
  final ctrl = TextEditingController();

  void onChange() {
    final EditableTextState s = key.currentState;
    final re = s.renderEditable;
    final pos = TextPosition(offset: re.selection.baseOffset);
    final anc = key.currentContext.ancestorRenderObjectOfType(const TypeMatcher<Scaffold>());
    final local = re.getLocalRectForCaret(pos);
    final global = re.localToGlobal(Offset(widget.cursorWidth, 0.0), ancestor: anc);

    widget.onCaretChange(local.translate(global.dx, global.dy));
  }

  @override
  void initState() {
    super.initState();

    if (widget.onCaretChange != null) {
      ctrl.addListener(onChange);
    }
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
      color: const Color(0x0A000000),
      child: EditableText(
        key: key,
        focusNode: node,
        controller: ctrl,
        cursorWidth: widget.cursorWidth,
        paintCursorAboveText: true,
        style: theme.textTheme.subhead,
        cursorColor: theme.primaryColor,
        backgroundCursorColor: theme.disabledColor,
      ),
    );
  }
}

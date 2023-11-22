import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

///Button using the [ULPTTheme]
class ULPTButton extends StatefulWidget {
  const ULPTButton({
    super.key,
    required this.enabled,
    required this.title,
    required this.onTap,
  });

  ///if false makes button not clickable
  final bool enabled;
  ///called when button is pressed
  final VoidCallback onTap;
  ///title used within the button
  final String title;

  @override
  State<ULPTButton> createState() => _ULPTButtonState();
}

class _ULPTButtonState extends State<ULPTButton> {

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;

    return OutlinedButton(
      focusNode: focusNode,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(widget.enabled ? theme.interactiveBGColor : theme.interactiveDisabledColor),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 8)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      onPressed: widget.enabled == false ? null : () async {
        if(focusNode.hasFocus == false){
          focusNode.requestFocus();
          await SchedulerBinding.instance.endOfFrame;
        }
        widget.onTap();
      },
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20,
          color: widget.enabled ? theme.interactiveFocusedColor : theme.interactiveFocusBGColor,
        ),
      ),
    );
  }
}
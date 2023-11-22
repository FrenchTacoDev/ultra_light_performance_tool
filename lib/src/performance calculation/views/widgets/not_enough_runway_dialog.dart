import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

///Dialog to show if the calculation resulted in not enough runway to be left.
class NotEnoughRunwayDialog extends StatelessWidget {
  const NotEnoughRunwayDialog({super.key, required this.overshoot, required this.factorizedNotEnough});

  static Future<void> show({
    required BuildContext context,
    required bool factorized,
    required int overshoot}) async{

    return await showDialog(
      context: context,
      builder: (context) {
        return NotEnoughRunwayDialog(factorizedNotEnough: factorized, overshoot: overshoot,);
      },
    );

  }

  final bool factorizedNotEnough;
  final int overshoot;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;
    var buttonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(color: theme.interactiveFocusedColor)),
    );
    var textStyle = TextStyle(color: theme.interactiveFocusedColor);

    return AlertDialog(
      title: Text(
        factorizedNotEnough ? "Startdistanz mit Aufschlag nicht ausreichend.\n${overshoot}m mehr benötigt!" :
        "Startdistanz nicht ausreichend.\n${overshoot}m mehr benötigt!",
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, true),
          style: buttonStyle,
          child: Text("OK", style: textStyle,),
        ),
      ],
    );
  }
}

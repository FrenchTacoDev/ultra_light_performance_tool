import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Confirmation Dialog using the [ULPTTheme]
class ULPTConfirmation extends StatelessWidget {
  const ULPTConfirmation({super.key, required this.title});

  final Widget title;

  ///If called will show the confirmation dialog and return true if the positive action has been called.
  ///For discard or negative will return false
  static Future<bool> show({required BuildContext context, required Widget title}) async{
    var res = await showDialog(
      context: context,
      builder: (context) {
        return ULPTConfirmation(title: title);
      },
    );

    return res == true ? true : false;
  }

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;
    var buttonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(color: theme.interactiveFocusedColor)),
    );
    var textStyle = TextStyle(color: theme.interactiveFocusedColor);

    return AlertDialog(
      title: title,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            style: buttonStyle,
            child: Text(Localizer.of(context).yes, style: textStyle,),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          style: buttonStyle,
          child: Text(Localizer.of(context).no, style: textStyle,),
        ),
      ],
    );
  }
}

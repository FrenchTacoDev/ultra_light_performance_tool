import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

///Checkmark using the [ULPTTheme]
class ULPTCheck extends StatelessWidget {
  const ULPTCheck({
    Key? key,
    required this.onChanged,
    required this.hintText,
    this.value,
  }) : super(key: key);

  final bool? value;
  final ValueSetter<bool?> onChanged;
  ///Shown next to the button
  final String hintText;


  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.interactiveBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Platform.isIOS ? 0 : 4, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  hintText,
                  style: TextStyle(color: theme.interactiveFocusedColor),
                )
            ),
            const SizedBox(width: 4,),
            Expanded(
                child: Checkbox(
                    fillColor: MaterialStateProperty.resolveWith((states) => theme.interactiveFocusedColor),
                    value: value ?? false,
                    onChanged: onChanged,
                )
            ),
          ],
        ),
      ),
    );
  }
}
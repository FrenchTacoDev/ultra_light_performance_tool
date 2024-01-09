import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

import 'takeoff_details.dart';

class DetailsButtons extends StatelessWidget {
  const DetailsButtons({super.key, this.isSmallSize = false});

  final bool isSmallSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: isSmallSize ? const EdgeInsets.all(2) : const EdgeInsets.fromLTRB(4, 0, 4, 2),
      child: _ButtonBar(),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  const _ButtonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        _Button(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TakeoffDetails(),)),
            text: "Details"
        ),
        _Button(onTap: () => print("2"), text: "Notes", enabled: false,),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({super.key, this.onTap, required this.text, this.enabled = true});

  final bool enabled;
  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(theme.interactiveBGColor),
        //padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 8)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
        onPressed: enabled ? onTap : null,
        child: Text(
          text,
          style: TextStyle(
            color: enabled ? theme.interactiveHintTextColor : theme.interactiveHintDisabledColor,
            fontSize: 16
          ),
        ),
    );
  }
}



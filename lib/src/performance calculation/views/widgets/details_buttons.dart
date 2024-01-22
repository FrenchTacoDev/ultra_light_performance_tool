import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/BLoC/calculation_bloc.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

import 'takeoff_details.dart';

class DetailsButtons extends StatelessWidget {
  const DetailsButtons({super.key, required this.state, this.isSmallSize = false});

  final bool isSmallSize;
  final CalculationState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: isSmallSize ? const EdgeInsets.all(2) : const EdgeInsets.fromLTRB(4, 0, 4, 2),
      child: _ButtonBar(state: state),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  const _ButtonBar({required this.state});

  final CalculationState state;

  @override
  Widget build(BuildContext context) {

    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        _Button(
            enabled: state.rawTod != null,
            onTap: (){
              var params = context.read<CalculationCubit>().getParameters(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeoffDetails(
                      parameters: params,
                      safetyFactor: 1 + (state.safetyFactor! / 100),
                      intersection: state.intersection!,
                    ),
                  )
              );
            },
            text: "Details"
        ),
        _Button(onTap: () => print("2"), text: "Notes", enabled: false,),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({this.onTap, required this.text, this.enabled = true});

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



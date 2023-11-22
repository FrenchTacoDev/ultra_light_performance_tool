import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';

///Dropdown to select the current runway conditions.
class RunwayConditionDropdown extends StatelessWidget {
  const RunwayConditionDropdown({
    Key? key,
    required this.onConditionChanged,
    required this.condition,
    this.isSmallSize = false,
  }) : super(key: key);

  ///Current selected [RunwayCondition]
  final RunwayCondition? condition;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<RunwayCondition> onConditionChanged;
  ///used for screen size adjustment
  final bool isSmallSize;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    if(isSmallSize){
      return Row(
        children: [
          SizedBox(
            width: theme.perfTextWidth,
            child: Text(
              "Zustand",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                color: theme.interactiveHintTextColor,
              ),
            ),
          ),
          Expanded(
            child: ULPTDropdown<RunwayCondition>(
              value: condition,
              items: RunwayCondition.values,
              hint: "Auswählen",
              alignRight: false,
              onChanged: onChanged,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ULPTDropdown<RunwayCondition>(
            value: condition,
            items: RunwayCondition.values,
            hint: "Auswählen",
            alignRight: true,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            "Zustand",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 18,
              color: theme.interactiveHintTextColor,
            ),
          ),
        ),
      ],
    );
  }

  void onChanged(RunwayCondition? value){
    if(value == null) return;
    onConditionChanged(value);
  }
}
import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Dropdown to select the runway.
class RwySelectDropdown extends StatelessWidget {
  const RwySelectDropdown({
    Key? key,
    this.value,
    this.airport,
    required this.onRunwayChanged
  }) : super(key: key);

  ///[Airport] that is selected in the calculation. If null will disable the field
  final Airport? airport;
  ///Current selected [Runway]
  final Runway? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<Runway> onRunwayChanged;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            Localizer.of(context).pcRwyTitle,
            style: TextStyle(
              fontSize: 18,
              color: theme.interactiveHintTextColor,
            ),
          ),
        ),
        Expanded(
          child: ULPTDropdown<Runway>(
            value: value,
            hint: Localizer.of(context).select,
            items: airport == null ? [] : airport!.runways,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void onChanged(Runway? r){
    if(r == null) return;
    onRunwayChanged(r);
  }
}

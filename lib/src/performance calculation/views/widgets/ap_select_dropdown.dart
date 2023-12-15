import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Dropdown to select the airport.
class APSelectDropDown extends StatelessWidget {
  const APSelectDropDown({super.key, required this.airportList, this.value, required this.onAirportSet});

  ///[Airport] list to choose from
  final List<Airport> airportList;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<Airport> onAirportSet;
  ///current selected [Airport]
  final Airport? value;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return Row(
      children: [
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            Localizer.of(context).pcAPTitle,
            style: TextStyle(
              fontSize: 18,
              color: theme.interactiveHintTextColor,
            ),
          ),
        ),
        Expanded(
          child: ULPTDropdown<Airport>(
              value: value,
              items: airportList,
              hint: Localizer.of(context).select,
              onChanged: (ap) {
                if(ap == null) return;
                onAirportSet(ap);
              }
          ),
        ),
      ],
    );
  }
}

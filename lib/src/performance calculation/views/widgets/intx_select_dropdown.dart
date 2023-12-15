import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Dropdown to select the intersection.
class IntersectionSelectDropdown extends StatelessWidget {
  const IntersectionSelectDropdown({
    Key? key,
    this.value,
    this.runway,
    required this.onIntersectionChanged
  }) : super(key: key);

  ///Current selected [Intersection]
  final Intersection? value;
  ///[Runway] that is selected in the calculation. If null will disable the field
  final Runway? runway;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<Intersection> onIntersectionChanged;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return Row(
      children: [
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            Localizer.of(context).pcIntersectTitle,
            style: TextStyle(
              fontSize: 18,
              color: theme.interactiveHintTextColor,
            ),
          ),
        ),
        Expanded(
          child: ULPTDropdown<Intersection>(
            value: value,
            parseItem: (item) {
              if(item == runway!.intersections.first
                  && runway!.intersections.isNotEmpty) return Localizer.of(context).full;
              return item.designator;
            },
            fromString: (s) {
              if(s == Localizer.of(context).full) return runway!.intersections.first;
              return runway!.intersections.where((element) => element.designator == s).first;
            },
            items: runway == null ? [] : runway!.intersections,
            hint: Localizer.of(context).select,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void onChanged(Intersection? value){
    if(value == null || runway == null) return;
    onIntersectionChanged(value);
  }
}
import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';

///[ULPTDropdown] to handle the runway surface selection.
class RunwaySurfaceDropdown extends StatelessWidget {
  const RunwaySurfaceDropdown({Key? key, required this.onSurfaceChanged, this.value}) : super(key: key);

  ///[Surface] value that will fill the field if set
  final Surface? value;
  ///callback function that is called when field is submitted
  final ValueSetter<Surface?> onSurfaceChanged;

  @override
  Widget build(BuildContext context) {
    return ULPTDropdown<Surface>(
      value: value ?? Surface.asphalt,
      items: Surface.values,
      parseItem: (item) => item.toLocString(context),
      hint: Localizer.of(context).rwySrfcDropdownHint,
      onChanged: onSurfaceChanged,
    );
  }
}
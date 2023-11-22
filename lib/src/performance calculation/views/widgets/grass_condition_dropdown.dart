import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/BLoC/calculation_bloc.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';

///Dropdown to select the current grass conditions.
class GrassConditionDropdown extends StatelessWidget {
  const GrassConditionDropdown({Key? key, required this.runway, this.value}) : super(key: key);

  ///[Runway] that is selected in the calculation. If null will disable the field
  final Runway? runway;
  ///Current selected [Underground]
  final Underground? value;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<CalculationCubit>();
    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return Row(
      children: [
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            "Gras",
            style: TextStyle(
              fontSize: 18,
              color: theme.interactiveHintTextColor,
            ),
          ),
        ),
        Expanded(
          child: ULPTDropdown<Underground>(
            value: value ?? Underground.firm,
            items: runway == null ? [] : Underground.values,
            hint: "Untergrund",
            onChanged: (value){
              if(value == null) return;
              cubit.setGrassSurface(underground: value);
            },
          ),
        ),
      ],
    );
  }
}
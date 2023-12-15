import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/BLoC/calculation_bloc.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_check.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Checkmark weather the grass is high or not
class HighGrass extends StatelessWidget {
  const HighGrass({Key? key, this.value}) : super(key: key);

  final bool? value;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<CalculationCubit>();

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return Row(
      children: [
        SizedBox(width: theme.perfTextWidth,),
        Expanded(
          child: ULPTCheck(
              onChanged: (b) => cubit.setGrassIsHigh(highGrass: b),
              value: value,
              hintText: Localizer.of(context).pcHighGrass,
          ),
        ),
      ],
    );
  }
}
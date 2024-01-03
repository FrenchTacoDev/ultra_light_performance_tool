import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_button.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'BLoC/add_aircraft_bloc.dart';
import 'widgets/ac_widgets.dart';

///This page is for adding and editing new aircraft. Contains its own [Scaffold] because it is pushed as a new route.
class AddAircraftPage extends StatelessWidget {
  const AddAircraftPage({super.key, required this.acManager, this.original});

  final AircraftManager acManager;
  final Aircraft? original;

  @override
  Widget build(BuildContext context) {

    return BlocProvider<AddAircraftCubit>(
      create: (context) => AddAircraftCubit(acManager: acManager, original: original),
      child: BlocBuilder<AddAircraftCubit, AddAircraftState>(
        builder: (context, state) {

          var cubit = context.read<AddAircraftCubit>();
          var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: BackButton(
                onPressed: () => cubit.onClose(context: context),
              ),
              title: original == null ?
              Text(Localizer.of(context).addACTitleCreate) :
              Text(Localizer.of(context).addACTitleEdit),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        ACNameEntry(
                          onNameSet: (n) => cubit.setName(name: n),
                          value: state.name,
                        ),
                        const SizedBox(height: 8,),
                        ACTodEntry(
                          onTodSet: (i) => cubit.setTOD(tod: i),
                          value: state.tod,
                        ),
                        const SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            textAlign: TextAlign.center,
                            Localizer.of(context).addACTodExplain,
                            style: TextStyle(color: theme.interactiveHintTextColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16,),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 100),
                          child: ULPTButton(
                              enabled: cubit.canSave(),
                              title: Localizer.of(context).save,
                              onTap: () async{
                                //To avoid context over async gap
                                closeFunc() => Navigator.pop(context);
                                if(await cubit.save()) closeFunc();
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

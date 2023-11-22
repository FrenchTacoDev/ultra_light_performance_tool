import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_button.dart';
import 'BLoC/add_aircraft_bloc.dart';
import 'widgets/ac_widgets.dart';

///This page is for adding and editing new aircraft. Contains its own [Scaffold] because it is pushed as a new route.
class AddAircraftPage extends StatelessWidget {
  const AddAircraftPage({super.key, required this.acManager, this.original});

  final AircraftManager acManager;
  final Aircraft? original;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: original == null ? const Text("Luftfahrzeug hinzufügen") : const Text("Luftfahrzeug bearbeiten"),
      ),
      body: BlocProvider<AddAircraftCubit>(
        create: (context) => AddAircraftCubit(acManager: acManager, original: original),
        child: BlocBuilder<AddAircraftCubit, AddAircraftState>(
          builder: (context, state) {

            var cubit = context.read<AddAircraftCubit>();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                      const SizedBox(height: 16,),
                      ULPTButton(
                          enabled: cubit.canSave(),
                          title: "Speichern",
                          onTap: () async{
                            //To avoid context over async gap
                            closeFunc() => Navigator.pop(context);
                            if(await cubit.save()) closeFunc();
                          }
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
    );
  }
}

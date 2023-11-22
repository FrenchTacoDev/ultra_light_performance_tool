import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_button.dart';

import 'BLoC/add_airport_bloc.dart';
import 'widgets/widgets.dart';

///Page to add or edit an airport.
class AddAirportPage extends StatelessWidget {
  const AddAirportPage({super.key, this.original});

  ///if null, page will open to add a new airport. Otherwise edit the given argument.
  final Airport? original;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: original == null ? const Text("Flugplatz hinzufügen") : const Text("Flugplatz bearbeiten"),
        ),
        body: BlocProvider<AddAirportCubit>(
          create: (context) => AddAirportCubit(original: original),
          child: BlocBuilder<AddAirportCubit, AddAirportState>(
            builder: (context, state) {

              var cubit = context.read<AddAirportCubit>();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          APNameEntry(
                            onNameSet: (n) => cubit.setName(name: n),
                            value: state.name,
                          ),
                          const SizedBox(height: 8,),
                          IcaoEntry(
                            onIcaoSet: (icao) => cubit.setIcao(icao: icao),
                            value: state.icao,
                          ),
                          const SizedBox(height: 8,),
                          IataEntry(
                            onIataSet: (iata) =>  cubit.setIata(iata: iata),
                            value: state.iata,
                          ),
                          const SizedBox(height: 8,),
                          ElevationEntry(
                            onElevationSet: (e) => cubit.setElevation(value: e),
                            value: state.elevation,
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            "Pisten",
                            style: TextStyle(
                                color: Theme.of(context).listTileTheme.titleTextStyle!.color,
                                fontSize: 22
                            ),
                          ),
                          const SizedBox(height: 8,),
                          RunwayList(
                            runways: state.runways ?? [],
                          ),
                          const SizedBox(height: 16,),
                          ULPTButton(
                              enabled: cubit.canSave(),
                              title: "Speichern",
                              onTap: () => cubit.save(context: context),
                          )
                        ],
                      ),
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

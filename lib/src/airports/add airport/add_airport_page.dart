import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
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

    return BlocProvider<AddAirportCubit>(
      create: (context) => AddAirportCubit(original: original),
      child: BlocBuilder<AddAirportCubit, AddAirportState>(
        builder: (context, state) {

          var cubit = context.read<AddAirportCubit>();

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: original == null ? Text(Localizer.of(context).apAddTitle) : Text(Localizer.of(context).apEditTitle),
              leading: BackButton(onPressed: () => cubit.onClose(context: context),),
            ),
            body: SingleChildScrollView(
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
                          Localizer.of(context).runways,
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
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 100),
                          child: ULPTButton(
                            enabled: cubit.canSave(),
                            title: Localizer.of(context).save,
                            onTap: () => cubit.save(context: context),
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

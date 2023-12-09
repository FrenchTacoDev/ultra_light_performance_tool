import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/airports/list/BLoC/airport_manage_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Panel to create, edit and delete Airports
class AirportManagePanel extends StatelessWidget {
  const AirportManagePanel({super.key});

  @override
  Widget build(BuildContext context) {

    var appCubit = context.read<ApplicationCubit>();

    return SafeArea(
      child: BlocProvider(
        create: (context) => AirportManageCubit(airportManager: appCubit.airportManager),
        child: BlocBuilder<AirportManageCubit, AirportManageState>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(Localizer.of(context).menuAirports),
            ),
            body: FutureBuilder<List<Airport>>(
              future: appCubit.airportManager.getAirports(),
              builder: (context, snapshot) {

                if(snapshot.hasError) return _ErrorScreen(error: snapshot.error!,);
                if(snapshot.hasData == false) return _ErrorScreen(error: Localizer.of(context).apManageNotFound);

                return Column(
                  children: [
                    Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (context, index) {

                          if(index == snapshot.data!.length) return const _AddAirportTile();

                          return _APListTile(
                            ap: snapshot.data![index],
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AddAirportTile extends StatelessWidget {
  const _AddAirportTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Icon(Icons.add, color: Theme.of(context).listTileTheme.titleTextStyle!.color,),
      onTap: () => context.read<AirportManageCubit>().addNewAirport(context: context),
    );
  }
}

class _APListTile extends StatelessWidget {
  const _APListTile({required this.ap});

  final Airport ap;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AirportManageCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text("${ap.icao} - ${ap.name}"),
          onTap: () => cubit.editAirport(context: context, airport: ap),
          trailing: IconButton(
              onPressed: () => cubit.deleteAirport(context: context, airport: ap),
              icon: const Icon(Icons.delete,)
          ),
          mouseCursor: SystemMouseCursors.click,
        ),
        Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
      ],
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("$error"),
    );
  }
}

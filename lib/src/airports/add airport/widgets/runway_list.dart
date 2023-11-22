import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/add%20airport/BLoC/add_airport_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';

///Lists an [Airport]s Runways as tiles to edit and add.
class RunwayList extends StatelessWidget {
  const RunwayList({super.key, required this.runways});

  final List<Runway> runways;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<AddAirportCubit>();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: runways.length + 1,
      itemBuilder: (context, index) {
        if(index == runways.length){
          return ListTile(
            title: Icon(Icons.add, color: Theme.of(context).listTileTheme.titleTextStyle!.color,),
            onTap: () => cubit.addNewRunway(context: context),
          );
        }

        var rwy = runways[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Piste ${rwy.designator}"),
              onTap: () => cubit.editRunway(context: context, original: rwy),
              trailing: IconButton(
                  onPressed: () => cubit.deleteRunway(context: context, runway: rwy),
                  icon: const Icon(Icons.delete, size: 18,)
              ),
            ),
            const SizedBox(height: 4,),
          ],
        );
      },
    );
  }
}

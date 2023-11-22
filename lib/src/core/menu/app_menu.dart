import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/application_cubit.dart';

///Menu for the Application
///[customMenuItems] can be added to expand on the menu and implement own behaviour.
///Must have a value that differs from 0, otherwise an error is thrown.
class AppMenu extends StatelessWidget {
  const AppMenu({super.key, this.customMenuItems});

  ///use this to add custom menu items like bug handling or about page.
  final List<PopupMenuItem<int>>? customMenuItems;

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<ApplicationCubit>();
    if(customMenuItems != null && customMenuItems!.any((element) => element.value == 0)) {
      throw FlutterError("customMenuItems should not contain items with value 0");
    }

    return PopupMenuButton<int>(
      icon: const Icon(Icons.menu),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
            value: 0,
            onTap: () => cubit.manageAirports(context: context),
            child: const Row(
              children: [
                Icon(Icons.flight_takeoff_outlined, size: 18),
                SizedBox(width: 8,),
                Text("Flugplätze verwalten"),
              ],
            )
        ),
        if(customMenuItems != null) ...customMenuItems!,
      ],
    );
  }
}

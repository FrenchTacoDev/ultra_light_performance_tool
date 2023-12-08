import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Menu for the Application
///[customMenuItems] can be added to expand on the menu and implement own behaviour.
///Must have a value that differs from 0, otherwise an error is thrown.
class AppMenu extends StatelessWidget {
  const AppMenu({super.key, this.customMenuItems});

  ///Use this to add custom menu items like bug handling or about page.
  ///Must be of Type [PopupMenuItem] but does not require a type or value. Instead use the onTap function.
  final List<PopupMenuItem>? customMenuItems;

  final List<int> _menuValues = const <int>[0,1];

  @override
  Widget build(BuildContext context) {

    var cubit = context.read<ApplicationCubit>();
    if(customMenuItems != null && customMenuItems!.any((element) => _menuValues.contains(element.value))) {
      throw FlutterError("customMenuItems should not contain items with value lower or equal then ${_menuValues.last}");
    }

    return PopupMenuButton(
      icon: const Icon(Icons.menu),
      itemBuilder: (context) => [
        PopupMenuItem(
            onTap: () => cubit.manageAirports(context: context),
            child: Row(
              children: [
                const Icon(Icons.flight_takeoff_outlined, size: 18),
                const SizedBox(width: 8,),
                Text(Localizer.of(context).menuAirports),
              ],
            )
        ),
        PopupMenuItem(
            onTap: () => cubit.openSettings(context: context),
            child: Row(
              children: [
                const Icon(Icons.settings_outlined, size: 18),
                const SizedBox(width: 8,),
                Text(Localizer.of(context).menuSettings),
              ],
            )
        ),
        if(customMenuItems != null) ...customMenuItems!,
      ],
    );
  }
}

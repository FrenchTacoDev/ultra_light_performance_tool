import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/aircraft/list/BLoC/aircraft_select_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Class that contains all aircraft currently in the database to select, add, edit or delete.
class AircraftSelectPanel extends StatelessWidget {
  const AircraftSelectPanel({
    super.key,
    required this.acManager,
    required this.onAircraftSelected,
  });

  ///[AircraftManager] that handles aircraft operation.
  final AircraftManager acManager;
  ///called on [Aircraft] selection to trigger further navigation actions
  final void Function({required Aircraft ac, required BuildContext context}) onAircraftSelected;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ACSelectCubit(aircraftManager: acManager),
      lazy: false,
      child: BlocBuilder<ACSelectCubit, ACSelectState>(
        builder: (context, state){
          return FutureBuilder<List<Aircraft>>(
            future: context.read<ACSelectCubit>().aircraftManager.getAircraft(),
            builder: (context, snapshot) {

              if(snapshot.hasError) return _ErrorScreen(error: snapshot.error!,);
              if(snapshot.hasData == false) return _ErrorScreen(error: Localizer.of(context).acSelectNotFound);

              return Column(
                children: [
                  Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                  ListTile(
                    title: Text(Localizer.of(context).acSelectTitle, textAlign: TextAlign.center),
                    titleAlignment: ListTileTitleAlignment.center,
                  ),
                  Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {

                        if(index == snapshot.data!.length) return const _AddACTile();

                        return _ACListTile(
                          ac: snapshot.data![index],
                          onSelected: (ac) => onAircraftSelected(context: context, ac: ac),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          );
        }
      ),
    );
  }
}

///Tile to add a new aircraft entry
class _AddACTile extends StatelessWidget {
  const _AddACTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Icon(Icons.add, color: Theme.of(context).listTileTheme.titleTextStyle!.color,),
        onTap: () => context.read<ACSelectCubit>().addNewAircraft(context: context),
    );
  }
}

///Tile that shows the respective aircraft.
class _ACListTile extends StatelessWidget {
  const _ACListTile({required this.ac, required this.onSelected});

  final Aircraft ac;
  final ValueSetter<Aircraft> onSelected;

  @override
  Widget build(BuildContext context) {

    var _optionsKey = GlobalKey(debugLabel: "acListTileOptionsKey");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onSelected(ac),
          onSecondaryTapUp: (d) => showMenuAt(
            context: context,
            pos: d.globalPosition,
            ac: ac,
          ),
          onLongPressStart: (d) => showMenuAt(
            context: context,
            pos: d.globalPosition,
            ac: ac,
          ),
          child: ListTile(
            title: Text(ac.name),
            trailing: IconButton(
              key: _optionsKey,
              onPressed: () => showMenuAt(
                  context: context,
                  pos: (_optionsKey.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero),
                  ac: ac
              ),
              iconSize: 20,
              icon: const Icon(
                Icons.edit,
                size: 18,
              ),
            ),
            mouseCursor: SystemMouseCursors.click,
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
      ],
    );
  }

  ///Used internally to show the menu at the long press or right click position.
  ///For the time being the menu has two options: Edit and Delete.
  void showMenuAt({required BuildContext context, required Offset pos, required Aircraft ac}) async{

    final overlay = Overlay.of(context).context.findRenderObject();
    if(overlay == null) return;
    var cubit = context.read<ACSelectCubit>();

    editFunction() => cubit.editAircraft(context: context, ac: ac);
    deleteFunction() => cubit.deleteAircraft(context: context, ac: ac);

    var contextAction = await showMenu<int?>(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(pos.dx, pos.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay.paintBounds.size.width, overlay.paintBounds.size.height)
        ),
        items: [
          PopupMenuItem(
            value: 0,
            child: Text(Localizer.of(context).edit),
          ),
          PopupMenuItem(
            value: 1,
            child: Text(Localizer.of(context).delete),
          ),
        ]
    );

    if(contextAction == null) return;
    if(contextAction == 0) return editFunction();
    if(contextAction == 1) return deleteFunction();
    throw FlutterError("No contextAction with index $contextAction found");
  }
}

///This widget is shown if an error occurred while fetching aircraft from the [AircraftManager]
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

library ulpt;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'src/aircraft/aircraft.dart';


///This is the main entry point for the App.
///When creating your own version of ULPT, just plug this widget into Flutters [runApp] function.
class ULPT extends StatelessWidget {
  const ULPT({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationCubit>(
      create: (context) => ApplicationCubit(),
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
          builder: (context, state) {
            return MaterialApp(
              title: "ULPT",
              theme: state.theme,
              home: MainPage(setupComplete: state.setupComplete),
            );
          },
      ),
    );
  }
}

///This is the main and starting page. Once the app setup is complete,
///this should show the collection of aircraft
class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.setupComplete});

  final bool setupComplete;

  @override
  Widget build(BuildContext context) {

    if(setupComplete == false) return const _WaitScreen();

    var appCubit = context.read<ApplicationCubit>();

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Ultra Light Performance Tool"),
            actions: const [
              //Todo add custom Menu Items to the API
              AppMenu(
                customMenuItems: [

                ],
              ),
              SizedBox(width: 16,),
            ],
          ),
          body: AircraftSelectPanel(
            acManager: appCubit.acManager,
            onAircraftSelected: appCubit.onAircraftSelected,
          ),
        )
    );
  }
}

class _WaitScreen extends StatelessWidget {
  const _WaitScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.green,
      ),
    );
  }
}

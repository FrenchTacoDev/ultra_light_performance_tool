library ulpt;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/import_export/import_export.dart';
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
            return Localizer(
              child: MaterialApp(
                title: "ULPT",
                theme: state.theme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: Settings.appLocals,
                home: MainPage(appState: state),
              ),
            );
          },
      ),
    );
  }
}

///This is the main and starting page. Once the app setup is complete,
///this should show the collection of aircraft
class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.appState});

  final ApplicationState appState;

  @override
  Widget build(BuildContext context) {

    if(appState.setupComplete == false) return const _WaitScreen();

    var appCubit = context.read<ApplicationCubit>();

    if(appState.appStartArgs != null) onAppStartArguments(context, appState.appStartArgs!);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
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

  void onAppStartArguments(BuildContext context, String args) async{
    var cubit = context.read<ApplicationCubit>();
    args = args.replaceAll(r'"', "");
    args = args.replaceAll(r'\', r'/');
    if(args.endsWith(".ulpt") == false) return;

    func() => ImportExport.startImportFromPath(context: context, filePath: args);
    await SchedulerBinding.instance.endOfFrame;
    await func();
    cubit.onAppStartArgumentsHandled();
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

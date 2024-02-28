library ulpt;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/import_export/import_export.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'src/aircraft/aircraft.dart';

export 'package:ultra_light_performance_tool/src/shared widgets/ulpt_button.dart' show ULPTButton;
export 'package:ultra_light_performance_tool/src/res/themes.dart' show ULPTTheme;
export 'package:ultra_light_performance_tool/src/localization/localizer.dart' show Localizer, Dictionary, CustomDict;

///This is the main entry point for the App.
///When creating your own version of ULPT, just plug this widget into Flutters [runApp] function.
class ULPT extends StatelessWidget {
  const ULPT({
    super.key,
    this.customMenuItems,
    this.customDictionaries,
    this.showDebugMode = true,
  });

  ///Pass your own [PopupMenuItem]s here to add items to the apps menu like an about page.
  ///A [BuildContext] is delivered with the getter so Access to the [ApplicationCubit] is also provided!
  final List<PopupMenuItem<dynamic>> Function(BuildContext context)? customMenuItems;

  ///Pass your own dictionaries for translation here.
  ///They are then available calling the [Localizer.of(context)] method.
  final List<CustomDict>? customDictionaries;

  final bool showDebugMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationCubit>(
      create: (context) => ApplicationCubit(theme: createDarkTheme(context)),
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
          builder: (context, state) {
            return Localizer(
              customDict: customDictionaries,
              child: MaterialApp(
                debugShowCheckedModeBanner: showDebugMode,
                title: "ULPT",
                theme: state.theme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: Settings.appLocals,
                home: MainPage(
                    appState: state,
                    customMenuItems: customMenuItems
                ),
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
  const MainPage({super.key, required this.appState, this.customMenuItems});

  final ApplicationState appState;
  final List<PopupMenuItem<dynamic>> Function(BuildContext context)? customMenuItems;

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
            actions:[
              AppMenu(
                customMenuItems: customMenuItems == null ? [] : customMenuItems!(context),
              ),
              const SizedBox(width: 16,),
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
    await cubit.onAppStartArgumentsHandled();
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

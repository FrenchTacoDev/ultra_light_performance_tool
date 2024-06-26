// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/database/savemanager.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/views/perf_calculation_panel.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'settings/settings.dart';

const MethodChannel _commChannel = MethodChannel("nativeCommChannel");

class ApplicationState{

  ///[ThemeData] for the application. Should contain a custom [ULPTTheme] as most theme data is derived by this.
  final ThemeData theme;
  ///if this is false, no cubit function should be called.
  ///The cubit will emit a new state with [setupComplete] being true once the setup is complete
  final bool setupComplete;
  ///Arguments the native app passed into the flutter app on startup. For now only supports file opening.
  final String? appStartArgs;

  ApplicationState({required this.theme, required this.setupComplete, this.appStartArgs});

  ApplicationState copyWith({ThemeData? theme, bool? setupComplete, String? appStartArgs}){
    return ApplicationState(theme: theme ?? this.theme, setupComplete: setupComplete ?? this.setupComplete, appStartArgs: appStartArgs ?? this.appStartArgs);
  }
}

class ApplicationCubit extends Cubit<ApplicationState>{
  ApplicationCubit({
    required ThemeData theme,
    SaveManager? saveManager,
    AircraftManager? acManager,
    AirportManager? airportManager,
    Settings? settings,
  }) : super(ApplicationState(theme: theme, setupComplete: false)){
    this.saveManager = saveManager ?? SaveManager();
    this.acManager = acManager ?? AircraftManager(saveManager: this.saveManager);
    this.airportManager = airportManager ?? AirportManager(saveManager: this.saveManager);
    setup();
  }

  ///Handles saving and loading
  late final SaveManager saveManager;
  ///handles all aircraft related tasks
  late final AircraftManager acManager;
  ///handles all airport related tasks
  late final AirportManager airportManager;
  ///handles user preferred app settings
  late Settings _settings;
  Settings get settings => _settings;
  set settings(Settings settings){
    _settings = settings;
    saveManager.saveSettings(settings: settings);
  }

  ///Usually this function is only called internally.
  ///If called will re-setup the current [SaveManager].
  Future<void> setup() async{
    WidgetsFlutterBinding.ensureInitialized();
    setupNativeCommunication();
    await saveManager.setup();
    settings = (await saveManager.getSettings()) ?? Settings();
    emit(state.copyWith(setupComplete: true));
  }

  ///Only called when there has been a change in saved data that is not accurately represented within the cache.
  Future<void> refresh() async{
    _settings = (await saveManager.getSettings()) ?? _settings;
  }

  ///Called to set a handler for the methdo channel with the native platform.
  ///Use [onCall] to inject your own logic.
  void setupNativeCommunication({ValueSetter<MethodCall>? onCall}){
    _commChannel.setMethodCallHandler((call) async{
      if(call.method == "onArgsFromNative" && call.arguments is String) _onAppStartupHasArgs(call.arguments);
      if(onCall != null) onCall(call);
    });
  }

  void _onAppStartupHasArgs(String args){
    if(args.isEmpty) return;
    emit(state.copyWith(appStartArgs: args));
  }

  Future<void> onAppStartArgumentsHandled() async{
    await refresh();
    var state = ApplicationState(theme: this.state.theme, setupComplete: this.state.setupComplete);
    emit(state);
  }

  ///Will open a new [AirportManagePanel]
  Future<void> manageAirports({required BuildContext context}) async{
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AirportManagePanel(),
        )
    );

    emit(state.copyWith());
  }

  ///Will open a [SettingsPanel] to change the app settings
  Future<void> openSettings({required BuildContext context}) async{
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsPanel(),
        )
    );

    emit(state.copyWith());
  }

  ///Handles what happens once an aircraft has been selected from the main page
  void onAircraftSelected({required Aircraft ac, required BuildContext context}) async{
    var airports = await airportManager.getAirports();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerformanceCalculationPanel(
            aircraft: ac,
            airportsList: airports,
            panelHeight: Platform.isIOS || Platform.isAndroid ? 360 : 330,
          ),
        )
    );
  }
}
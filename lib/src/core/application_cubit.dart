// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/database/savemanager.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/views/perf_calculation_panel.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'settings/settings.dart';

class ApplicationState{

  ///[ThemeData] for the application. Should contain a custom [ULPTTheme] as most theme data is derived by this.
  final ThemeData theme;
  ///if this is false, no cubit function should be called.
  ///The cubit will emit a new state with [setupComplete] being true once the setup is complete
  final bool setupComplete;

  ApplicationState({required this.theme, required this.setupComplete});

  ApplicationState copyWith({ThemeData? theme, bool? setupComplete}){
    return ApplicationState(theme: theme ?? this.theme, setupComplete: setupComplete ?? this.setupComplete);
  }
}

class ApplicationCubit extends Cubit<ApplicationState>{
  ApplicationCubit({
    SaveManager? saveManager,
    AircraftManager? acManager,
    AirportManager? airportManager,
    Settings? settings,
  }) : super(ApplicationState(theme: darkTheme, setupComplete: false)){
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
    await saveManager.setup();
    settings = (await saveManager.getSettings()) ?? Settings();
    emit(state.copyWith(setupComplete: true));
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
            panelHeight: Platform.isIOS ? 370 : 320,
          ),
        )
    );
  }
}
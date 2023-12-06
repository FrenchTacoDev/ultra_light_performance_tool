import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';
import 'widgets/factor_adjust.dart';

///Used to bundle information about how the user wants the app to behave
class Settings{

  //json keys for Corrections
  static String correctionsFieldValue = "perfCorrections";

  Settings();

  Corrections corrections = Corrections();

  Settings copy(){
    var settings = Settings();
    settings.corrections = corrections.copy();
    return settings;
  }

  ///transform class into json representation
  Map<String, dynamic> serialize(){
    return {
      correctionsFieldValue : jsonEncode(corrections.serialize()),
    };
  }

  ///transform json representation into dart class
  factory Settings.deserialize({required Map<String, dynamic> map}){
    var settings = Settings();
    var corJson = map[correctionsFieldValue];

    settings.corrections = corJson == null ? settings.corrections : Corrections.deserialize(map: jsonDecode(corJson));

    return settings;
  }

  @override
  bool operator ==(Object other) {
    return other is Settings
        && other.corrections == corrections;
  }

  //Todo for now only a const value as hash which is just a workaround and doesn't make sense. Resolve when more params are present.
  @override
  int get hashCode => Object.hash(1, corrections);
}

///Panel to set the settings of the app
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {

    var appCubit = context.read<ApplicationCubit>();

    return SafeArea(
        child: BlocProvider<_SettingsPanelCubit>(
          create: (context) => _SettingsPanelCubit(appCubit: appCubit, settings: appCubit.settings),
          child: BlocBuilder<_SettingsPanelCubit, _SettingsPanelState>(
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text("Einstellungen"),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Faktoren Anpassen"),
                          subtitle: const Text("Passen Sie die Faktoren für die Performance-Berechnung an."),
                          onTap: () => context.read<_SettingsPanelCubit>().setCorrections(context: context),
                        ),
                        //Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                        //Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
              );
            },
          ),
        ),
    );
  }
}

class _SettingsPanelState{
  _SettingsPanelState._({required this.settings});
  factory _SettingsPanelState.initial({required Settings settings}) => _SettingsPanelState._(settings: settings.copy());

  final Settings settings;

  _SettingsPanelState copyWidth({Settings? settings}){
    return _SettingsPanelState._(settings: settings ?? this.settings);
  }
}

class _SettingsPanelCubit extends Cubit<_SettingsPanelState>{
  _SettingsPanelCubit({required this.appCubit, Settings? settings}) : super(_SettingsPanelState.initial(settings: settings ?? Settings()));

  ApplicationCubit appCubit;

  Future<void> setCorrections({required BuildContext context}) async{
    var cor = await Navigator.push<Corrections?>(
        context,
        MaterialPageRoute(
          builder: (context) => FactorAdjustPanel(corrections: state.settings.corrections),
        )
    );

    if(cor == null) return;
    var newSettings = state.settings.copy()..corrections = cor.copy();
    appCubit.settings = newSettings;
    emit(state.copyWidth(settings: newSettings));
  }
}
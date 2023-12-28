import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/import_export/import_export.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_dropdown.dart';
import 'widgets/factor_adjust.dart';

///Used to bundle information about how the user wants the app to behave
class Settings{

  //json keys for Corrections
  static String correctionsFieldValue = "perfCorrections";
  //json keys for language
  static String languageFieldValue = "language";

  Settings();

  Corrections corrections = Corrections();
  Locale? locale;

  Settings copy(){
    var settings = Settings();
    settings.corrections = corrections.copy();
    settings.locale = locale;
    return settings;
  }

  ///transform class into json representation
  Map<String, dynamic> serialize(){
    return {
      correctionsFieldValue : jsonEncode(corrections.serialize()),
      languageFieldValue : locale?.languageCode,
    };
  }

  ///transform json representation into dart class
  factory Settings.deserialize({required Map<String, dynamic> map}){
    var settings = Settings();
    var corJson = map[correctionsFieldValue];

    settings.corrections = corJson == null ? settings.corrections : Corrections.deserialize(map: jsonDecode(corJson));
    settings.locale = appLocals.where((l) => l.languageCode == map[languageFieldValue]).firstOrNull;

    return settings;
  }

  @override
  bool operator ==(Object other) {
    return other is Settings
        && other.corrections == corrections
        && other.locale == locale;
  }

  @override
  int get hashCode => Object.hash(corrections, locale);

  //Single point of acces for the app on what languages are supported.
  static List<Locale> appLocals = [
    const Locale.fromSubtags(countryCode: "GB", languageCode: "en"),
    const Locale.fromSubtags(countryCode: "DE", languageCode: "de"),
  ];

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
              return BlocListener<ApplicationCubit, ApplicationState>(
                listener: (context, appState) {
                  if(appCubit.settings == state.settings) return;
                  context.read<_SettingsPanelCubit>().onSettingsChangedExt(settings: appCubit.settings);
                },
                child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(Localizer.of(context).menuSettings),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            minVerticalPadding:16,
                            title: Text(Localizer.of(context).language),
                            trailing: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 200,),
                                child: ULPTDropdown(
                                  items: languageLocalMap.keys.toList(),
                                  hint: Localizer.of(context).select,
                                  value: _getLanguage(context: context, state: state),
                                  onChanged: (l) => context.read<_SettingsPanelCubit>().setLocal(locale: languageLocalMap[l]),
                                )
                            ),
                          ),
                          Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
                          ListTile(
                            title: Text(Localizer.of(context).facAdjustTitle),
                            subtitle: Text(Localizer.of(context).facAdjustSubTitle),
                            onTap: () => context.read<_SettingsPanelCubit>().setCorrections(context: context),
                          ),
                          Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
                          ListTile(
                            title: Text("Import"),
                            subtitle: Text("Start the import of ULPT data"),
                            onTap: () => context.read<_SettingsPanelCubit>().startImport(context: context),
                          ),
                          Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
                          ListTile(
                            title: Text("Export"),
                            subtitle: Text("Start the export of ULPT data"),
                            onTap: () => context.read<_SettingsPanelCubit>().startExport(context: context),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                ),
              );
            },
          ),
        ),
    );
  }

  Map<String, Locale> get languageLocalMap => {
    "English" : Settings.appLocals.where((l) => l.languageCode == "en").first,
    "Deutsch" : Settings.appLocals.where((l) => l.languageCode == "de").first,
  };

  String _getLanguage({required BuildContext context, required _SettingsPanelState state}){
    if(state.settings.locale != null) return languageLocalMap.entries.where((kv) => kv.value == state.settings.locale).firstOrNull?.key ?? "English";
    return languageLocalMap.entries.where((kv) => kv.value.languageCode == Localizations.localeOf(context).languageCode).firstOrNull?.key ?? "English";
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
  _SettingsPanelCubit({required this.appCubit, Settings? settings}) :
        super(_SettingsPanelState.initial(settings: settings ?? Settings()));

  ApplicationCubit appCubit;

  void onSettingsChangedExt({required Settings settings}){
    emit(state.copyWidth(settings: settings));
  }

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

  Future<void> setLocal({required Locale? locale}) async{
    if(locale == null) return;
    if(locale == state.settings.locale) return;
    var newSettings = state.settings.copy()..locale = locale;
    appCubit.settings = newSettings;
    emit(state.copyWidth(settings: newSettings));
  }

  Future<void> startExport({required BuildContext context}) async{
    await ImportExport.startExport(context: context);
  }

  Future<void> startImport({required BuildContext context}) async{
    await ImportExport.startImport(context: context);
    await appCubit.refresh();
    emit(state.copyWidth(settings: appCubit.settings));
  }
}
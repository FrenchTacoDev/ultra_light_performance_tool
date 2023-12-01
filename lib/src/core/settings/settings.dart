import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';
import 'widgets/factor_adjust.dart';

//json keys for Corrections
const _correctionsFieldValue = "perfCorrections";

///Used to bundle information about how the user wants the app to behave
class Settings{

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
      _correctionsFieldValue : jsonEncode(corrections.serialize()),
    };
  }

  ///transform json representation into dart class
  factory Settings.deserialize({required Map<String, dynamic> map}){
    var settings = Settings();
    var corJson = map[_correctionsFieldValue];

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
    return SafeArea(
        child: Scaffold(
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
                    onTap: () async{
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FactorAdjustPanel(),
                          )
                      );
                    },
                  ),
                  //Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                  //Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
                  const SizedBox(height: 16),
                ],
              ),
            )
        )
    );
  }
}
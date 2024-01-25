import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ultra_light_performance_tool/ulpt.dart';


void main() {

  //This is needed to setup SQLite FFI so the database library can work on desktop!
  if(io.Platform.isWindows ||io.Platform.isMacOS){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
      ULPT(
        //Example how to implement english and german transaltions for custom dictionary
        customDictionaries: [
          ENCustom(),
          DECustom(),
        ],
        //Example how to implement custom menu buttons
        customMenuItems: (context) {
          return [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.dashboard_customize_outlined, size: 18),
                  SizedBox(width: 8,),
                  Text("Custom Menu"),
                ],
              ),
              onTap: () => showCustomMenuDialog(context: context),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.translate_outlined, size: 18),
                  SizedBox(width: 8,),
                  Text("Custom Translation"),
                ],
              ),
              onTap: () => showCustomLocalizationDialog(context: context),
            )
          ];
        },
      )
  );
}

//Shows an example dialog
Future<void> showCustomMenuDialog({required BuildContext context}){
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Custom Menu Action"),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK")
          )
        ],
      );
    },
  );
}

//Shows an example dialog
Future<void> showCustomLocalizationDialog({required BuildContext context}){
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text((Localizer.of(context).customDict! as CustomDictionary).helloYou, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Localizer.of(context).ok)
          )
        ],
      );
    },
  );
}

//Example how to implement english and german transaltions for custom dictionary
abstract class CustomDictionary implements CustomDict{
  String get helloYou;
}

class ENCustom implements CustomDictionary{
  @override
  String get helloYou => "Hello You!";

  @override
  String get languageTag => "en";
}

class DECustom implements CustomDictionary{
  @override
  String get helloYou => "Hallo Du!";

  @override
  String get languageTag => "de";
}



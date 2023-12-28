import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/database/savemanager.dart';

///This class takes the internal ULPT data and serializes it into json format before compressing it using zlib.
class ExportProcessor{

  static Future<Uint8List> createExportData({
    required SaveManager saveManager,
    bool exportSettings = false,
  }) async{
    var apJsonList = <String>[];

    for(var ap in await saveManager.getAllAirports()){
      apJsonList.add(jsonEncode(await ap.serialize()));
      await Future.delayed(Duration.zero);
    }

    var acJsonList = [];

    for(var ac in await saveManager.getAllAircraft()){
      acJsonList.add(jsonEncode(ac.serialize()));
      await Future.delayed(Duration.zero);
    }

    String? settingsJson;

    if(exportSettings){
      var sets = await saveManager.getSettings();
      if(sets != null) settingsJson = jsonEncode(sets.serialize());
    }

    var exportJsonString = jsonEncode({
      "Airports" : apJsonList,
      "Aircraft" : acJsonList,
      if(settingsJson != null) "Settings" : settingsJson,
    });

    await Future.delayed(Duration.zero);
    ZLibCodec codec = ZLibCodec();
    return Uint8List.fromList(codec.encode(exportJsonString.codeUnits));
  }
}
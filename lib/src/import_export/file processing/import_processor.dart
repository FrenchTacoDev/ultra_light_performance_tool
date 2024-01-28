import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/settings/settings.dart';
import 'package:ultra_light_performance_tool/src/database/savemanager.dart';

///This class uses ulpt data that has previously been serialized.
///First decompresses zlib to deserialize from json afterwards.
class ImportProcessor{

  static Future<void> processImportData({
    required Uint8List data,
    required SaveManager saveManager,
    bool importSettings = false
  }) async{

    ZLibCodec codec = ZLibCodec();
    var decoded = const Utf8Decoder(allowMalformed: true).convert(codec.decode(data));
    var jsonMap = jsonDecode(decoded);

    var apJsons = jsonMap["Airports"] as List<dynamic>?;
    var acJsons = jsonMap["Aircraft"] as List<dynamic>?;
    var settingsJson = jsonMap["Settings"] as String?;

    var allAirports = await saveManager.getAllAirports();

    if(apJsons != null){
      for(var apJson in apJsons){
        var ap = await Airport.deserialize(map: jsonDecode(apJson));
        await Future.delayed(Duration.zero);
        if(allAirports.contains(ap)) continue;
        await saveManager.addAirport(airport: ap);
      }
    }

    var allAc = await saveManager.getAllAircraft();

    if(acJsons != null){
      for(var acJson in acJsons){
        var ac = Aircraft.deserialize(map: jsonDecode(acJson));
        await Future.delayed(Duration.zero);
        if(allAc.contains(ac)) continue;
        await saveManager.addAircraft(aircraft: ac);
      }
    }

    if(importSettings == false || settingsJson == null) return;
    await saveManager.saveSettings(settings: Settings.deserialize(map: jsonDecode(settingsJson)));
  }
}
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'ulpt_db.dart';

///Handles saving and loading.
///[setup] must be called and completed before any other function.
class SaveManager{

  static const int currentDBVersion = 2;

  final ULPTDB database = ULPTDB(currentDBVersion: currentDBVersion);

  Future<void> setup() async{
    await database.setup();
  }

  Future<int> addAircraft({required Aircraft aircraft}) async{
    return database.addToTable(table: ULPTDB.acTableName, data: aircraft.serialize());
  }

  Future<void> removeAircraft({required Aircraft aircraft}) async{
    if(aircraft.dbid == null) return;
    return database.removeFromTable(table: ULPTDB.acTableName, id: aircraft.dbid!);
  }

  Future<void> editAircraft({required Aircraft original, required Aircraft substitute}) async{
    if(original.dbid == null) return;
    return database.editInTable(table: ULPTDB.acTableName, id: original.dbid!, data: substitute.serialize());
  }

  Future<List<Aircraft>> getAllAircraft() async{
    var acMaps = await database.getAllFromTable(table: ULPTDB.acTableName);
    var ac = <Aircraft>[];

    for(int i = 0; i < acMaps.length; i++){
      ac.add(Aircraft.deserialize(map: acMaps[i]));
      if(i % 10 == 0) await Future.delayed(Duration.zero);
    }

    return ac;
  }

  Future<int> addAirport({required Airport airport}) async{
    return database.addToTable(table: ULPTDB.apTableName, data: await airport.serialize());
  }

  Future<void> removeAirport({required Airport airport}) async{
    if(airport.dbid == null) return;
    return database.removeFromTable(table: ULPTDB.apTableName, id: airport.dbid!);
  }

  Future<void> editAirport({required Airport original, required Airport substitute}) async{
    if(original.dbid == null) return;
    return database.editInTable(table: ULPTDB.apTableName, id: original.dbid!, data: await substitute.serialize());
  }

  Future<List<Airport>> getAllAirports() async{
    var apMaps = await database.getAllFromTable(table: ULPTDB.apTableName);
    var aps = <Airport>[];

    for(int i = 0; i < apMaps.length; i++){
      aps.add(await Airport.deserialize(map: apMaps[i]));
      if(i % 10 == 0) await Future.delayed(Duration.zero);
    }

    return aps;
  }

  Future<Settings?> getSettings() async{
    var settingsMap = await database.getAllFromTable(table: ULPTDB.settingsTableName);
    assert(settingsMap.length <= 1);
    if(settingsMap.isEmpty) return null;
    assert(settingsMap.first["id"] == 1);
    return Settings.deserialize(map: settingsMap.first);
  }

  Future<void> saveSettings({required Settings settings}) async{
    if(await getSettings() == null){
      var res = await database.addToTable(table: ULPTDB.settingsTableName, data: settings.serialize());
      assert(res == 1);
      return;
    }

    database.editInTable(table: ULPTDB.settingsTableName, id: 1, data: settings.serialize());
  }
}
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/settings/settings.dart';
import 'package:ultra_light_performance_tool/src/database/workqueue.dart';
import 'package:sqflite/sqflite.dart' as sq;

///Database Handler for the app
///should not call anything but [setup] as long as [isWorking] is not true.
///
class ULPTDB{

  static const String databaseName = "ULPT_Database.db";
  static const String acTableName = "Aircraft";
  static const String apTableName = "Airports";
  static const String settingsTableName = "Settings";

  ULPTDB({required this.currentDBVersion});

  final int currentDBVersion;
  late final String dbPath;
  late DBWorkQueue workQueue;
  late sq.Database _db;
  bool isWorking = false;

  Future<void> setup() async{
    _fillUpgradeList();
    dbPath = join((await getApplicationDocumentsDirectory()).path, "ULPT", databaseName);
    await _openDatabase();
    await _db.close();

    workQueue = DBWorkQueue(
        onWorkStarted: () async{
          if(_db.isOpen) return;
          return await _openDatabase();
        },
        onWorkFinished: () async => await _db.close()
    );

    isWorking = true;
  }

  Future<void> _openDatabase() async{
    _db = await sq.openDatabase(dbPath, version: currentDBVersion, onCreate: _onDBCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onDBCreate(db, version) async{
    await _createAircraftTable(db);
    await _createAirportTable(db);
    await _createSettingsTable(db);
  }
  
  Future<int> addToTable({required String table, required Map<String, dynamic> data}) async{
    if(isWorking == false) throw("Database not prepared");
    var work = Work<int>(workFunction: () async => await _db.insert(table, data),);
    workQueue.scheduleNewWork(work);
    return work.completer.future;
  }

  Future<List<Map<String, dynamic>>> getAllFromTable({required String table}) async{
    if(isWorking == false) throw("Database not prepared");
    var work = Work<List<Map<String, dynamic>>>(workFunction: () async => await _db.query(table));
    workQueue.scheduleNewWork(work);
    return work.completer.future;
  }

  Future<void> removeFromTable({required String table, required int id}) async{
    if(isWorking == false) throw("Database not prepared");
    var work = Work<void>(
        workFunction: () async => await _db.delete(table, where: "id = ?", whereArgs: [id])
    );
    workQueue.scheduleNewWork(work);
    return work.completer.future;
  }

  Future<void> editInTable({required String table, required int id, required Map<String, dynamic> data}) async{
    if(isWorking == false) throw("Database not prepared");
    var work = Work<void>(
        workFunction: () async => await _db.update(table, data, where: "id = ?", whereArgs: [id]),
    );
    workQueue.scheduleNewWork(work);
    return work.completer.future;
  }

  Future<void> _createAircraftTable(sq.Database db) async{
    await db.execute(
        'CREATE TABLE $acTableName '
            '(id INTEGER PRIMARY KEY,'
            ' ${Aircraft.nameFieldValue} TEXT,'
            ' ${Aircraft.todFieldValue} INTEGER,'
            ' ${Aircraft.notesFieldValue} TEXT)'
    );
  }

  Future<void> _createAirportTable(sq.Database db) async{
    await db.execute(
        'CREATE TABLE $apTableName '
            '(id INTEGER PRIMARY KEY,'
            ' ${Airport.nameFieldValue} TEXT,'
            ' ${Airport.icaoFieldValue} TEXT,'
            ' ${Airport.iataFieldValue} TEXT,'
            ' ${Airport.elevationFieldValue} INTEGER,'
            ' ${Airport.notesFieldValue} TEXT,'
            ' ${Airport.runwayFieldValue} TEXT)'
    );
  }

  Future<void> _createSettingsTable(sq.Database db) async{
    await db.execute(
        'CREATE TABLE $settingsTableName '
            '(id INTEGER PRIMARY KEY,'
            ' ${Settings.correctionsFieldValue} TEXT,'
            ' ${Settings.languageFieldValue} TEXT)'
    );
  }

  //region Upgrade
  late final List<AsyncValueSetter<sq.Database>> _upgradeMethods;

  void _fillUpgradeList(){
    _upgradeMethods = [
          (d) => _upgradeTo2(d),
          (d) => _upgradeTo3(d),
    ];
  }

  Future<void> _onUpgrade(sq.Database db, int oldV, int newV) async{
    int currentV = oldV;
    assert(currentV < currentDBVersion);

    while(currentV != currentDBVersion){
      await _upgradeMethods[currentV - 1](db);
      currentV = await db.getVersion();
    }
  }

  Future<void> _upgradeTo2(sq.Database d) async{
    _createSettingsTable(d);
    d.setVersion(2);
  }

  Future<void> _upgradeTo3(sq.Database d) async{
    await d.execute("ALTER TABLE $acTableName ADD ${Aircraft.notesFieldValue} TEXT");
    await d.execute("ALTER TABLE $apTableName ADD ${Airport.notesFieldValue} TEXT");
    d.setVersion(3);
  }
  //endregion
}
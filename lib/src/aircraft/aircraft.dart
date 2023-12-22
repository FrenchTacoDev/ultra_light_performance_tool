library aircraft;

import 'package:ultra_light_performance_tool/src/database/savemanager.dart';
export 'list/aircraft_select_panel.dart';

///Data representation for Aircraft
class Aircraft{

  static const String nameFieldValue = "name";
  static const String todFieldValue = "tod";

  const Aircraft({this.dbid, required this.name, required this.todr});

  ///internal DatabaseID to handle saving and loading
  final int? dbid;
  final String name;
  ///takeoff distance required in meters
  final int todr;

  Aircraft copyWith({int? dbid, String? name, int? todr}){
    return Aircraft(
        dbid: dbid ?? this.dbid,
        name: name ?? this.name,
        todr: todr ?? this.todr
    );
  }

  ///transform class into json representation
  Map<String, dynamic> serialize(){
    return {
      nameFieldValue : name,
      todFieldValue : todr,
    };
  }

  ///transform json representation into dart class
  static Aircraft deserialize({required Map<String, dynamic> map}){
    return Aircraft(
        dbid: map["id"],
        name: map[nameFieldValue] ?? "Missing Name",
        todr: map[todFieldValue] ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Aircraft
        && other.name == name
        && other.todr == todr;
  }

  @override
  int get hashCode => Object.hash(name, todr);
}

///Class to handle all [Aircraft]
class AircraftManager{

  late final SaveManager _saveManager;

  ///[saveManager] is required to handle database operations
  AircraftManager({required SaveManager saveManager}){
    _saveManager = saveManager;
  }

  List<Aircraft> _aircraftList = [];

  Future<void> addAircraft({required Aircraft aircraft}) async{
    if(_aircraftList.contains(aircraft)) return;
    var id = await _saveManager.addAircraft(aircraft: aircraft);
    _aircraftList.add(aircraft.copyWith(dbid: id));
  }

  Future<List<Aircraft>> getAircraft() async{
    _aircraftList = await _saveManager.getAllAircraft();
    _aircraftList.sort((a, b) => a.name.compareTo(b.name),);
    return _aircraftList;
  }

  Future<void> editAircraft({required Aircraft original, required Aircraft substitute}) async{
    if(_aircraftList.contains(original) == false) throw("Unable to edit Aircraft ${original.name} since it is not contained in the Database");
    _aircraftList[_aircraftList.indexOf(original)] = substitute;
    _saveManager.editAircraft(original: original, substitute: substitute);
  }

  Future<void> deleteAircraft({required Aircraft aircraft}) async{
    if(_aircraftList.contains(aircraft) == false) return;
    _aircraftList.remove(aircraft);
    _saveManager.removeAircraft(aircraft: aircraft);
  }
}
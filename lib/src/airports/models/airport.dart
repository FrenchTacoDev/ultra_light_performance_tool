import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/database/savemanager.dart';
import 'runway.dart';

///Data representation of Airport
class Airport{

  static const String nameFieldValue = "name";
  static const String icaoFieldValue = "icao";
  static const String iataFieldValue = "iata";
  static const String elevationFieldValue = "elevation";
  static const String notesFieldValue = "apNotes";
  static const String runwayFieldValue = "runways";

  ///internal DatabaseID to handle saving and loading
  final int? dbid;
  final String name;
  ///4-letter ICAO code
  final String icao;
  ///3 Letter IATA code
  final String? iata;
  final List<Runway> runways;
  ///in feet as [int]
  final int elevation;
  final String? notes;

  const Airport({
    this.dbid,
    required this.name,
    required this.icao,
    this.iata,
    required this.runways,
    required this.elevation,
    this.notes,
  });


  @override
  String toString() => icao;

  @override
  int get hashCode => Object.hash(name, icao, iata, runways, elevation, notes);

  Airport copyWithID(int id){
    return Airport(
        dbid: id,
        name: name,
        icao: icao,
        iata: iata,
        runways: List.of(runways),
        elevation: elevation,
        notes: notes,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Airport
        && other.name == name
        && other.icao == icao
        && other.iata == iata
        && listEquals(other.runways, runways)
        && other.elevation == elevation
        && other.notes == notes;
  }

  ///transform class into json representation
  Future<Map<String, dynamic>> serialize() async{

    var rwyMaps = <Map<String, dynamic>>[];

    for(var rwy in runways){
      rwyMaps.add(await rwy.serialize());
      await Future.delayed(Duration.zero);
    }

    return {
      nameFieldValue : name,
      icaoFieldValue : icao,
      iataFieldValue : iata,
      elevationFieldValue : elevation,
      notesFieldValue : notes,
      runwayFieldValue : jsonEncode(rwyMaps),
    };
  }

  ///transform json representation into dart class
  static Future<Airport> deserialize({required Map<String, dynamic> map}) async{

    var rwys = <Runway>[];
    var rwyMaps = jsonDecode(map[runwayFieldValue] ?? []);

    for(var rwyMap in rwyMaps){
      rwys.add(await Runway.deserialize(map: rwyMap));
      await Future.delayed(Duration.zero);
    }

    return Airport(
      dbid: map["id"],
      name: map[nameFieldValue] ?? "Missing Name",
      icao: map[icaoFieldValue] ?? "Missing ICAO",
      iata: map[iataFieldValue],
      elevation: map[elevationFieldValue] ?? 0,
      notes: map[notesFieldValue],
      runways: rwys,
    );
  }
}

///Class to handle all [Airport]
class AirportManager{

  AirportManager({required SaveManager saveManager}){
    _saveManager = saveManager;
  }

  late final SaveManager _saveManager;

  List<Airport> _airportList = [];

  Future<void> addAirport({required Airport airport}) async{
    if(_airportList.contains(airport)) return;
    var id = await _saveManager.addAirport(airport: airport);
    _airportList.add(airport.copyWithID(id));
  }

  Future<List<Airport>> getAirports() async{
    _airportList.sort((a, b) => a.icao.compareTo(b.icao),);
    if(_airportList.isNotEmpty) return _airportList;
    _airportList = await _saveManager.getAllAirports();
    _airportList.sort((a, b) => a.icao.compareTo(b.icao),);
    return _airportList;
  }

  Future<void> editAirport({required Airport original, required Airport substitute}) async{
    if(_airportList.contains(original) == false) throw("Unable to edit Airport ${original.icao} since it is not contained in the Database");
    _airportList[_airportList.indexOf(original)] = substitute;
    return _saveManager.editAirport(original: original, substitute: substitute);
  }

  Future<void> deleteAirport({required Airport airport}) async{
    if(_airportList.contains(airport) == false) return;
    _airportList.remove(airport);
    _saveManager.removeAirport(airport: airport);
  }
}
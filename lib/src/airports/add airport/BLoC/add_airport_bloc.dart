import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/add%20runway/add_runway_page.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_confirmation.dart';

class AddAirportState{

  AddAirportState._({
    this.name,
    this.icao,
    this.iata,
    this.elevation,
    this.notes,
    this.runways,
  });

  final String? name;
  ///should be a 4-Letter ICAO code
  final String? icao;
  ///should be a 3-Letter IATA code
  final String? iata;
  ///in feet
  final int? elevation;
  final String? notes;
  final List<Runway>? runways;

  factory AddAirportState.initial({Airport? original}){
    return AddAirportState._(
      name: original?.name,
      icao: original?.icao,
      iata: original?.iata,
      elevation: original?.elevation,
      notes: original?.notes,
      runways: original?.runways,
    );
  }

  AddAirportState copyWith({
    String? name,
    String? icao,
    String? iata,
    int? elevation,
    String? notes,
    List<Runway>? runways,
  }){
    return AddAirportState._(
      name: name != null && name.isEmpty ? null : name ?? this.name,
      icao: icao != null && icao.isEmpty ? null : icao ?? this.icao,
      iata: iata != null && iata.isEmpty ? null : iata ?? this.iata,
      elevation: elevation ?? this.elevation,
      notes:  notes != null && notes.isEmpty ? null : notes ?? this.notes,
      runways: runways != null ? List.of(runways) : this.runways != null ? List.of(this.runways!) : null,
    );
  }

  bool hasEntries(){
    return name != null || icao != null || iata != null || elevation != null || notes != null || (runways != null && runways!.isNotEmpty);
  }

  bool matchesAirport(Airport ap){
    return ap.name == name && ap.icao == icao && ap.iata == iata && ap.elevation == elevation && ap.notes == notes && listEquals(ap.runways, runways);
  }
}

///Handles the logic of the AddAirportPage
class AddAirportCubit extends Cubit<AddAirportState>{
  AddAirportCubit({this.original}) :
        super(AddAirportState.initial(original: original));

  final Airport? original;

  bool get isEdit => original != null;

  void setName({String? name}){
    emit(state.copyWith(name: name ?? ""));
  }

  void setIcao({String? icao}){
    emit(state.copyWith(icao: icao ?? ""));
  }

  void setIata({String? iata}){
    emit(state.copyWith(iata: iata ?? ""));
  }

  void setElevation({int? value}) {
    emit(state.copyWith(elevation: value));
  }

  void setNotes({String? notes}) {
    emit(state.copyWith(notes: notes ?? ""));
  }

  ///Opens up a new [AddRunwayPage] to enter [Runway] information
  void addNewRunway({required BuildContext context}) async{
    var rwy = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRunwayPage(),));
    if(rwy == null) return;
    var s = state.runways == null ? state.copyWith(runways: []) : state.copyWith();
    if(s.runways!.contains(rwy)) return;
    s.runways!.add(rwy);
    emit(s);
  }

  ///Opens up a new [AddRunwayPage] to edit [Runway] information
  void editRunway({required BuildContext context, required Runway original}) async{
    var rwy = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddRunwayPage(original: original),)
    );
    if(rwy == null || state.runways == null) return;
    if(rwy == original) return;
    var s = state.copyWith();
    s.runways![s.runways!.indexOf(original)] = rwy;
    emit(s);
  }

  void deleteRunway({required BuildContext context, required Runway runway}) async{

    var res = await ULPTConfirmation.show(
      context: context,
      title: Text(
        Localizer.of(context).deleteRunwayConfirm,
        textAlign: TextAlign.center,
      ),
    );

    if(res == false) return;
    if(state.runways == null) return;

    var s = state.copyWith();
    s.runways!.remove(runway);
    emit(s);
  }

  bool canSave(){
    return state.name != null && state.name!.isNotEmpty
        && state.icao != null && state.icao!.isNotEmpty
        && state.elevation != null
        && state.runways != null && state.runways!.isNotEmpty;
  }

  Future<void> onClose({required BuildContext context}) async{
    pop() => Navigator.pop(context);
    if(state.hasEntries() == false) return pop();
    if(original != null && state.matchesAirport(original!)) return pop();
    var res = await ULPTConfirmation.show(context: context, title: Text(Localizer.of(context).discardChangesWarning, textAlign: TextAlign.center,));
    if(res == true) pop();
  }

  ///Pops the Page and returns the airport to the caller
  Future<void> save({required BuildContext context}) async{
    if(canSave() == false) return emit(state.copyWith());

    late Airport ap;

    if(isEdit) {
      ap = Airport(
        name: state.name ?? original!.name,
        icao: state.icao ?? original!.icao,
        iata: state.iata,
        elevation: state.elevation ?? original!.elevation,
        notes: state.notes,
        runways: state.runways ?? original!.runways,
      );

      return Navigator.pop(context, ap);
    }

    ap = Airport(
      name: state.name!,
      icao: state.icao!,
      iata: state.iata,
      elevation: state.elevation!,
      notes: state.notes,
      runways: state.runways!,
    );

    Navigator.pop(context, ap);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_confirmation.dart';

class AddAircraftState{

  final String? name;
  final int? tod;
  final String? notes;

  AddAircraftState._({this.name, this.tod, this.notes});

  factory AddAircraftState.initial({String? name, int? tod, String? notes}){
    return AddAircraftState._(name: name, tod: tod, notes: notes);
  }

  AddAircraftState copyWith({String? name, int? tod, String? notes,}){
    return AddAircraftState._(name: name ?? this.name, tod: tod ?? this.tod, notes: notes ?? this.notes);
  }

  bool hasEntries() {
    return name != null || tod != null || notes != null;
  }

  bool matchesAircraft(Aircraft ac) {
    return ac.name == name && ac.todr == tod && ac.notes == notes;
  }
}

///Used to handle the logic of adding and editing aircraft
class AddAircraftCubit extends Cubit<AddAircraftState>{
  //Todo refactor so that state takes Aircraft as argument every parameter
  AddAircraftCubit({required this.acManager, this.original}) :
        super(AddAircraftState.initial(name: original?.name, tod: original?.todr, notes: original?.notes));

  final AircraftManager acManager;
  final Aircraft? original;

  bool get isEdit => original != null;

  void setName({required String? name}){
    emit(AddAircraftState.initial(name: name, tod: state.tod, notes: state.notes));
  }

  void setTOD({required int? tod}){
    emit(AddAircraftState.initial(name: state.name, tod: tod, notes: state.notes));
  }

  void setNotes({String? notes}) {
    emit(AddAircraftState.initial(name: state.name, tod: state.tod, notes: notes));
  }

  bool canSave(){
    return state.name != null && state.name!.isNotEmpty && state.tod != null && state.tod! > 0;
  }

  Future<void> onClose({required BuildContext context}) async{
    pop() => Navigator.pop(context);
    if(state.hasEntries() == false) return pop();
    if(original != null && state.matchesAircraft(original!)) return pop();
    var res = await ULPTConfirmation.show(context: context, title: Text(Localizer.of(context).entriesLostWarning, textAlign: TextAlign.center,));
    if(res == true) pop();
  }

  Future<bool> save() async{
    if(canSave() == false){
      emit(state.copyWith());
      return false;
    }

    if(isEdit) {
      await acManager.editAircraft(original: original!, substitute: Aircraft(name: state.name!, todr: state.tod!, notes: state.notes));
    } else {
      await acManager.addAircraft(aircraft: Aircraft(name: state.name!, todr: state.tod!, notes: state.notes));
    }

    return true;
  }
}
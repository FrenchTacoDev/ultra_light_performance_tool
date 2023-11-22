import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';

class AddAircraftState{

  final String? name;
  final int? tod;

  AddAircraftState._({this.name, this.tod});

  factory AddAircraftState.initial({String? name, int? tod}){
    return AddAircraftState._(name: name, tod: tod);
  }

  AddAircraftState copyWith({String? name, int? tod}){
    return AddAircraftState._(name: name ?? this.name, tod: tod ?? this.tod);
  }
}

///Used to handle the logic of adding and editing aircraft
class AddAircraftCubit extends Cubit<AddAircraftState>{
  AddAircraftCubit({required this.acManager, this.original}) :
        super(AddAircraftState.initial(name: original?.name, tod: original?.todr));

  final AircraftManager acManager;
  final Aircraft? original;

  bool get isEdit => original != null;

  void setName({required String? name}){
    emit(AddAircraftState.initial(name: name, tod: state.tod));
  }

  void setTOD({required int? tod}){
    emit(AddAircraftState.initial(name: state.name, tod: tod));
  }

  bool canSave(){
    return state.name != null && state.name!.isNotEmpty && state.tod != null && state.tod! > 0;
  }

  Future<bool> save() async{
    if(canSave() == false){
      emit(state.copyWith());
      return false;
    }

    if(isEdit) {
      await acManager.editAircraft(original: original!, substitute: Aircraft(name: state.name!, todr: state.tod!));
    } else {
      await acManager.addAircraft(aircraft: Aircraft(name: state.name!, todr: state.tod!));
    }

    return true;
  }
}
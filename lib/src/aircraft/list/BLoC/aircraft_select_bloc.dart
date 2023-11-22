import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/add_aircraft/add_aircraft_page.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_confirmation.dart';

class ACSelectState{
  ACSelectState copyWith(){
    return ACSelectState();
  }
}

///Handles all logic concerning [Aircraft] selection
class ACSelectCubit extends Cubit<ACSelectState>{
  ACSelectCubit({required this.aircraftManager}) : super(ACSelectState());

  ///required to handle [Aircraft] adding, editing and deletion
  final AircraftManager aircraftManager;

  ///Adds a new aircraft via the [AircraftManager]
  Future<void> addNewAircraft({required BuildContext context}) async{
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddAircraftPage(
              acManager: aircraftManager,
          ),
        )
    );

    emit(state.copyWith());
  }

  ///Edits the selected aircraft via the [AircraftManager]
  Future<void> editAircraft({required BuildContext context, required Aircraft ac}) async{
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddAircraftPage(
            acManager: aircraftManager,
            original: ac,
          ),
        )
    );

    emit(state.copyWith());
  }

  ///Deletes the selected aircraft via the [AircraftManager]. Will prompt the user for confirmation.
  Future<void> deleteAircraft({required BuildContext context, required Aircraft ac}) async{
    var res = await ULPTConfirmation.show(
        context: context,
        title: Text("${ac.name} wirklich löschen?", textAlign: TextAlign.center,)
    );

    if(res == false) return;

    await aircraftManager.deleteAircraft(aircraft: ac);
    emit(state.copyWith());
  }
}
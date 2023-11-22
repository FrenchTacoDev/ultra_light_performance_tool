import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/add%20airport/add_airport_page.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_confirmation.dart';

class AirportManageState{
  AirportManageState copy(){
    return AirportManageState();
  }
}

///Handles all logic to the AirportManagePanel
class AirportManageCubit extends Cubit<AirportManageState>{
  AirportManageCubit({required this.airportManager})
      : super(AirportManageState());

  final AirportManager airportManager;

  Future<void> addNewAirport({required BuildContext context}) async{
    var ap = await Navigator.push<Airport?>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddAirportPage(),
        )
    );

    if(ap == null) return;
    await airportManager.addAirport(airport: ap);
    emit(state.copy());
  }

  Future<void> editAirport({required BuildContext context, required Airport airport}) async{
    var substitute = await Navigator.push<Airport?>(
        context,
        MaterialPageRoute(
          builder: (context) => AddAirportPage(
              original: airport
          ),
        )
    );

    if(substitute == null || substitute == airport) return;
    await airportManager.editAirport(original: airport, substitute: substitute);
    emit(state.copy());
  }

  Future<void> deleteAirport({required BuildContext context, required Airport airport}) async{

    var res = await ULPTConfirmation.show(
      context: context,
      title: const Text(
          "Flugplatz wiklich löschen?",
          textAlign: TextAlign.center
      ),
    );

    if(res == false) return;

    await airportManager.deleteAirport(airport: airport);
    emit(state.copy());
  }
}
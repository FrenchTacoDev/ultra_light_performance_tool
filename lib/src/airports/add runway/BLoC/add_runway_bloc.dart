import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_confirmation.dart';

class AddRunwayState{

  AddRunwayState._({
    this.designator,
    this.direction,
    this.surface,
    this.startElevation,
    this.endElevation,
    this.slope,
    this.intersections,
  });

  final String? designator;
  ///must be within 0 - 360 degrees
  final int? direction;
  final Surface? surface;
  ///used for computing [slope]
  final int? startElevation;
  ///used for computing [slope]
  final int? endElevation;
  ///when given overrides computed value
  final double? slope;
  final List<Intersection>? intersections;

  factory AddRunwayState.initial({Runway? rwy}){
    return AddRunwayState._(
      designator: rwy?.designator,
      direction: rwy?.direction,
      startElevation: rwy?.startElevation,
      endElevation: rwy?.endElevation,
      slope: rwy?.slope,
      surface: rwy?.surface ?? Surface.asphalt,
      //Uses placeholder Full for first intersect as this resembles full runway. Text shown to the user is however resolved by localization.
      //See AddRunwayPage for this.
      intersections: rwy?.intersections ?? [const Intersection(designator: "Full", toda: 0)],
    );
  }

  AddRunwayState copyWith({
    String? designator, int? direction, Surface? surface,
    int? startElevation, int? endElevation, double? slope,
    List<Intersection>? intersections,
  }){

    return AddRunwayState._(
      designator: designator ?? this.designator,
      direction: direction ?? this.direction,
      surface: surface ?? this.surface,
      slope: slope ?? this.slope,
      startElevation: startElevation ?? this.startElevation,
      endElevation: endElevation ?? this.endElevation,
      intersections: intersections ?? this.intersections,
    );
  }

  bool hasEntries() {
    return designator != null || direction != null || startElevation != null
        || endElevation != null || slope != null || (intersections != null && intersections!.isNotEmpty && intersections!.first.toda != 0);
  }

  bool matchesRunway(Runway r) {
    return r.designator == designator && r.direction == direction && r.startElevation == startElevation
        && r.endElevation == endElevation && r.slope == slope && listEquals(r.intersections, intersections);
  }
}

///Handles the logic of the AddRunwayPage
class AddRunwayCubit extends Cubit<AddRunwayState>{
  AddRunwayCubit({this.original}) :
        super(AddRunwayState.initial(rwy: original));

  final Runway? original;
  bool get isEdit => original != null;

  void setDesignator({String? designator}){
    emit(state.copyWith(designator: designator));
  }

  void setDirection({int? direction}){
    emit(state.copyWith(direction: direction));
  }

  void setSurface({Surface? surface}){
    emit(state.copyWith(surface: surface));
  }

  void setSlope({double? slope}){
    if(slope == state.slope) return;

    //Todo check for max or min slope, maybe already in entry.
    emit(AddRunwayState.initial().copyWith(
        designator: state.designator,
        surface: state.surface,
        direction: state.direction,
        slope: slope
    ));
  }

  ///Calculates slope automatically if endElevation and full distance are given
  void setStartElevation({int? elevation}){
    if(state.startElevation == elevation) return;

    var s = AddRunwayState.initial().copyWith(
        designator: state.designator,
        surface: state.surface,
        direction: state.direction,
        startElevation: elevation,
        endElevation: state.endElevation,
        intersections: state.intersections,
    );

    emit(s);
    _calculateSlope();
  }

  ///Calculates slope automatically if startElevation and full distance are given
  void setEndElevation({int? elevation}){
    if(state.endElevation == elevation) return;

    var s = AddRunwayState.initial().copyWith(
      designator: state.designator,
      surface: state.surface,
      direction: state.direction,
      startElevation: state.startElevation,
      endElevation: elevation,
      intersections: state.intersections,
    );

    emit(s);
    _calculateSlope();
  }

  ///Adds a new intersection card where the user then can enter the designator and the toda
  void addIntersection(){
    var intersects = List<Intersection>.from(state.intersections ?? [])..add(const Intersection(designator: "", toda: 0));
    emit(state.copyWith(intersections: intersects));
  }

  void setIntersectionDesignator({required Intersection intersection, String? designator}){
    if(state.intersections!.contains(intersection) == false) throw("Intersection not contained");
    state.intersections![state.intersections!.indexOf(intersection)] = Intersection(designator: designator ?? "", toda: intersection.toda);
    emit(state.copyWith(intersections: List<Intersection>.from(state.intersections!)));
  }

  void setIntersectionTOD({required Intersection intersection, int? tod}){
    if(state.intersections!.contains(intersection) == false) throw("Intersection not contained");
    var index = state.intersections!.indexOf(intersection);
    state.intersections![index] = Intersection(designator: intersection.designator, toda: tod ?? 0);
    emit(state.copyWith(intersections: List<Intersection>.from(state.intersections!)));
    if(index == 0) _calculateSlope();
  }

  void deleteIntersection({required BuildContext context, required Intersection intersection}) async{

    var res = await ULPTConfirmation.show(
      context: context,
      title: Text(
        Localizer.of(context).rwyIntersectDelConfirm,
        textAlign: TextAlign.center,
      ),
    );

    if(res == false) return;

    state.intersections?.remove(intersection);
    var intersects = List<Intersection>.from(state.intersections ?? []);
    emit(state.copyWith(intersections: intersects));
  }

  bool canSave(){

    if(state.intersections == null) return false;
    var fullToda = state.intersections!.first.toda;

    for(var inter in state.intersections!){
      if(inter.toda <= 0) return false;
      if(inter.toda > fullToda) return false;
    }

    return state.designator != null && state.designator!.isNotEmpty
      && state.direction != null
      && state.surface != null;
  }

  Future<void> onClose({required BuildContext context}) async{
    pop() => Navigator.pop(context);
    if(state.hasEntries() == false) return pop();
    if(original != null && state.matchesRunway(original!)) return pop();
    var res = await ULPTConfirmation.show(context: context, title: Text(Localizer.of(context).entriesLostWarning, textAlign: TextAlign.center,));
    if(res == true) pop();
  }

  Future<void> save({required BuildContext context}) async{
    if(canSave() == false) return emit(state.copyWith());
    if(isEdit) {
      return Navigator.pop(
        context,
        Runway(
            designator: state.designator ?? original!.designator,
            direction: state.direction ?? original!.direction,
            surface: state.surface ?? original!.surface,
            startElevation: state.startElevation ?? original!.startElevation,
            endElevation: state.endElevation ?? original!.endElevation,
            slope: state.slope ?? original!.slope,
            intersections: state.intersections ?? List.from(original!.intersections),
        )
      );
    }

    return Navigator.pop(
        context,
        Runway(
          designator: state.designator!,
          direction: state.direction!,
          intersections: state.intersections!,
          surface: state.surface!,
          startElevation: state.startElevation,
          endElevation: state.endElevation,
          slope: state.slope ?? 0,
        )
    );
  }

  void _calculateSlope() {
    bool canCalculateSlope = state.startElevation != null && state.endElevation != null && state.intersections != null && state.intersections!.first.toda > 0;
    if(canCalculateSlope == false) return;

    var slope = (((state.endElevation! / 3.2808) - (state.startElevation!/3.2808)) / state.intersections!.first.toda) * 100;
    slope = double.parse(slope.toStringAsFixed(2));
    emit(state.copyWith(slope: slope));
  }
}
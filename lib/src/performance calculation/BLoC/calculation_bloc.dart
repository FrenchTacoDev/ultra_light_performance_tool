import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/performance calculation/calculations.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/views/widgets/not_enough_runway_dialog.dart';

///Holds all user entries and required variables for the performance calc
class CalculationState{
  final Airport? airport;
  final Runway? runway;
  final Intersection? intersection;
  final Underground? underground;
  final bool? sodDamaged;
  final bool? highGrass;
  final RunwayCondition? runwayCondition;
  final int? temp;
  final Wind? wind;
  final int? qnh;
  final int? safetyFactor;
  final int? rawTod;
  int? get factorizedTod{
    if(rawTod == null) return null;
    var fac = safetyFactor == null ? 1.0 : 1.0 + (safetyFactor! / 100);
    return (rawTod! * fac).ceil();
  }

  CalculationState._({
    this.airport,
    this.runway,
    this.intersection,
    this.underground,
    this.sodDamaged,
    this.highGrass,
    this.runwayCondition,
    this.temp,
    this.wind,
    this.qnh,
    this.safetyFactor,
    this.rawTod,
  });

  factory CalculationState.initial() => CalculationState._();
  CalculationState copyWith({
    Airport? airport,
    Runway? runway,
    Intersection? intersection,
    Underground? underground,
    bool? sodDamaged,
    bool? highGrass,
    RunwayCondition? runwayCondition,
    int? temp,
    Wind? wind,
    int? qnh,
    int? safetyFactor,
    int? rawTod,
  }){
    return CalculationState._(
      airport: airport ?? this.airport,
      runway: runway ?? this.runway,
      intersection: intersection ?? this.intersection,
      underground: underground ?? this.underground,
      sodDamaged: sodDamaged ?? this.sodDamaged,
      highGrass: highGrass ?? this.highGrass,
      runwayCondition: runwayCondition ?? this.runwayCondition,
      temp: temp ?? this.temp,
      wind: wind ?? this.wind,
      qnh: qnh ?? this.qnh,
      safetyFactor: safetyFactor ?? this.safetyFactor,
      rawTod: rawTod ?? this.rawTod,
    );
  }

  CalculationState resetTod(){
    return CalculationState._(
      airport: airport,
      runway: runway,
      intersection: intersection,
      underground: underground,
      sodDamaged: sodDamaged,
      highGrass: highGrass,
      runwayCondition: runwayCondition,
      temp: temp,
      wind: wind,
      qnh: qnh,
      safetyFactor: safetyFactor,
      rawTod: null,
    );
  }
}

///Handles all operations regarding the performance calculation
class CalculationCubit extends Cubit<CalculationState>{
  CalculationCubit({required this.aircraft}) : super(CalculationState.initial());

  //Todo private plus public getter
  bool canCalc = false;
  ///[Aircraft] that was selected previously by the user
  final Aircraft aircraft;

  ///Used for controlling the scroll motion when view needs scrolling
  final ScrollController scrollControl = ScrollController();

  @override
  Future<void> close() async{
    scrollControl.dispose();
    return super.close();
  }

  ///checks on every state change if a calc can be done or not
  @override
  void emit(CalculationState state) {
    canCalc = state.airport != null && state.runway != null && state.intersection != null
        && state.runwayCondition != null && state.temp != null && state.wind != null
        && state.qnh != null;

    super.emit(state);
  }

  void setAirport({required Airport airport}) {
    if(airport == state.airport) return;
    emit(CalculationState.initial().copyWith(
        airport: airport,
        safetyFactor: state.safetyFactor
    ));
  }

  void setRunway({required Runway runway}) {
    if(runway == state.runway) return;
    emit(
        CalculationState.initial().copyWith(
            airport: state.airport,
            runway: runway,
            intersection: runway.intersections.first,
            underground: runway.surface == Surface.grass ? Underground.firm : null,
            temp: state.temp,
            qnh: state.qnh,
            safetyFactor: state.safetyFactor,
        )
    );
  }

  void setIntersection({required Intersection intersection}) {
    if(intersection == state.intersection) return;
    emit(state.copyWith(intersection: intersection));
  }

  //Todo think about if a reset is necessary on grass surface change?
  void setGrassSurface({required Underground underground}){
    if(state.runway?.surface != Surface.grass || state.underground == underground) return;

    emit(
        CalculationState.initial().copyWith(
          airport: state.airport,
          runway: state.runway,
          intersection: state.intersection,
          underground: underground,
        )
    );
  }

  void setGrassIsHigh({bool? highGrass}){
    if(highGrass == null || state.highGrass == highGrass) return;
    emit(state.copyWith(highGrass: highGrass));
    emit(state.resetTod());
  }

  void setSodDamaged({bool? sodDamaged}){
    if(sodDamaged == null || state.sodDamaged == sodDamaged) return;
    emit(state.copyWith(sodDamaged: sodDamaged));
    emit(state.resetTod());
  }

  void setRunwayCondition({RunwayCondition? condition}){
    if(condition == null || state.runwayCondition == condition) return;
    emit(state.copyWith(runwayCondition: condition));
    emit(state.resetTod());
  }

  void setTemperature({int? temp}){
    if(state.temp == temp) return;
    emit(
      CalculationState.initial().copyWith(
        temp: temp,
        runwayCondition: state.runwayCondition,
        highGrass: state.highGrass,
        intersection: state.intersection,
        runway: state.runway,
        underground: state.underground,
        airport: state.airport,
        qnh: state.qnh,
        safetyFactor: state.safetyFactor,
        sodDamaged: state.sodDamaged,
        wind: state.wind
      )
    );
  }

  void setWind({Wind? wind}){
    if(state.wind == wind) return;
    emit(
        CalculationState.initial().copyWith(
            wind: wind,
            temp: state.temp,
            runwayCondition: state.runwayCondition,
            highGrass: state.highGrass,
            intersection: state.intersection,
            runway: state.runway,
            underground: state.underground,
            airport: state.airport,
            qnh: state.qnh,
            safetyFactor: state.safetyFactor,
            sodDamaged: state.sodDamaged,
        )
    );
  }

  void setQNH({int? qnh}) {
    if(state.qnh == qnh) return;
    emit(
        CalculationState.initial().copyWith(
          qnh: qnh,
          wind: state.wind,
          temp: state.temp,
          runwayCondition: state.runwayCondition,
          highGrass: state.highGrass,
          intersection: state.intersection,
          runway: state.runway,
          underground: state.underground,
          airport: state.airport,
          safetyFactor: state.safetyFactor,
          sodDamaged: state.sodDamaged,
        )
    );
  }

  void setSafetyFactor({int? factor}) {
    if(state.qnh == factor) return;
    emit(
        CalculationState.initial().copyWith(
          safetyFactor: factor,
          qnh: state.qnh,
          wind: state.wind,
          temp: state.temp,
          runwayCondition: state.runwayCondition,
          highGrass: state.highGrass,
          intersection: state.intersection,
          runway: state.runway,
          underground: state.underground,
          airport: state.airport,
          sodDamaged: state.sodDamaged,
        )
    );
  }

  CalculationParameters getParameters(BuildContext context){
    if(canCalc == false) throw("Calculation State requires more values to be complete!");
    return CalculationParameters(
        corrections: context.read<ApplicationCubit>().settings.corrections,
        rawTod:  aircraft.todr,
        runway: state.runway!,
        airport: state.airport!,
        qnh: state.qnh!,
        temp: state.temp!,
        wind: state.wind!,
        underground: state.underground,
        highGrass: state.highGrass ?? false,
        sodDamaged: state.sodDamaged ?? false,
        runwayCondition: state.runwayCondition!
    );
  }

  ///Runs the calculation and will automatically warn the user if distance is not sufficient.
  void calculate({required BuildContext context}){
    var calc = PerformanceCalculator(
      parameters: getParameters(context),
    );

    emit(state.copyWith(rawTod: calc.calculateUnfactored().ceil()));
    FocusScope.of(context).focusedChild?.unfocus();
    if(state.factorizedTod == null && state.intersection?.toda == null) return;

    var remainingFac = state.intersection!.toda - state.factorizedTod!;
    var remainingUnFac = state.intersection!.toda - state.rawTod!;

    if(scrollControl.positions.isNotEmpty) {
      scrollControl.animateTo(
          scrollControl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.decelerate
      );
    }

    if(remainingFac >= 0) return;

    if(remainingUnFac < 0){
      NotEnoughRunwayDialog.show(
          context: context,
          factorized: false,
          overshoot: remainingUnFac * -1
      );
      return;
    }

    NotEnoughRunwayDialog.show(
        context: context,
        factorized: true,
        overshoot: remainingFac * -1
    );
  }
}


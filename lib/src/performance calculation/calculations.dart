import 'dart:math';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';

typedef Wind = ({int direction, int speed});

///Data Container for the performance calculation
class CalculationParameters{

  const CalculationParameters({
    required this.corrections,
    required this.rawTod,
    required this.runway,
    required this.airport,
    required this.qnh,
    required this.temp,
    required this.wind,
    required this.runwayCondition,
    this.underground,
    this.highGrass = false,
    this.sodDamaged = false,
  });

  final Corrections corrections;
  final int rawTod;
  final Runway runway;
  final Airport airport;
  final int qnh;
  final int temp;
  final Wind wind;
  final Underground? underground;
  final bool highGrass;
  final bool sodDamaged;
  final RunwayCondition runwayCondition;

  @override
  bool operator ==(Object other) {
    return other is CalculationParameters
        && other.corrections == corrections
        && other.rawTod == rawTod
        && other.runway == runway
        && other.airport == airport
        && other.qnh == qnh
        && other.temp == temp
        && other.wind == wind
        && other.underground == underground
        && other.highGrass == highGrass
        && other.sodDamaged == sodDamaged
        && other.runwayCondition == runwayCondition;
  }

  @override
  int get hashCode => Object.hash(corrections, rawTod, runway, airport, qnh,
      temp, wind, underground, highGrass, sodDamaged, runwayCondition);

}

///Class that handles all the calculations
///Must be given all parameters on construction first.
///Then call the [calculateUnfactored] function to get a result without safety margin.
class PerformanceCalculator{

  final CalculationParameters parameters;

  const PerformanceCalculator({
    required this.parameters,
  });

  double _calculateSlopeFactor() => (parameters.runway.slope / 10) + 1;

  ///Calculates real pressure altitude
  double calculatePressureAltitude() => 30.0 * (1013.0 - parameters.qnh) + parameters.airport.elevation;

  double _calculatePressureFactor(){
    var pa = calculatePressureAltitude();
    if(pa <= 0) return 1.0;
    if(pa <= 1000) return (pa / 1000) * (1 / 10) + 1;
    if(pa <= 3000) return (pa / 1000) * (13 / 100) + 1;
    return (pa / 1000) * (18 / 100) + 1;
  }

  ///Assumes a decrease of 2°C per 1000ft alt
  double calculateIsaDelta(double pressureAlt){
    var isaTemp = pressureAlt <= 0 ? 15.0 : 15.0 - ((pressureAlt / 1000) * 2);
    var currentTemp = parameters.temp < 0 ? 0 : parameters.temp;
    return currentTemp - isaTemp;
  }

  double _calculateTempFactor(double pressureAlt){
    var deltaT = calculateIsaDelta(pressureAlt);
    return deltaT >= 0 ? deltaT / 100 + 1 : 1 + deltaT / 100;
  }

  ///Positive value means headwind, negative tailwind
  double calculateHeadwindComponent(){
    var angle = _getWindAngle();
    if(angle == 90) return 0.0;
    return parameters.wind.speed * cos((angle * pi) / 180);
  }

  ///Positive value means wind from the right, negative from the left
  double calculateCrosswindComponent(){
    var angle = _getWindAngle();
    if(angle == 0 || angle == 180) return 0.0;
    var cwc = parameters.wind.speed * sin((angle * pi) / 180);
    if(_windIsFromLeft()) return -cwc;
    return cwc;

  }

  bool _windIsFromLeft(){
    var wind = parameters.wind.direction * pi / 180;
    var rwy = parameters.runway.direction * pi / 180;
    var cp = cos(wind) * sin(rwy) - sin(wind) * cos(rwy);
    if(cp > 0) return true;
    return false;
  }

  double calculateWindFactor(double hwc){
    var windFac = 1.0;
    if(hwc < 0) windFac = (hwc / 10).abs() * (parameters.corrections.tailWindFactor - 1) + 1;
    if(hwc > 0) windFac = 1 - (hwc / 10).abs() * (parameters.corrections.headWindFactor - 1);
    return windFac < 0 ? 0 : windFac;
    //Todo think about what makes sense when headwind is so strong that the tod is 0
    //Either 0 => all becomes 0 or 0.1 or 0.01 for a very small number
  }

  double _getWindAngle() => (parameters.wind.direction - parameters.runway.direction + 360) % 360;

  double getUndergroundFactor() => {
    Underground.firm : parameters.corrections.grassFactorFirm,
    Underground.wet : parameters.corrections.grassFactorWet,
    Underground.softened : parameters.corrections.grassFactorSoftened,
  }[parameters.underground] ?? 1.0;

  double getSodDamagedFactor() => parameters.sodDamaged ? parameters.corrections.sodDamagedFactor : 1.0;
  double getHighGrassFactor() => parameters.highGrass ? parameters.corrections.highGrassFactor : 1.0;

  double getContaminationFactor() => {
    RunwayCondition.dry : 1.0,
    RunwayCondition.wet : parameters.corrections.conditionFactorWet,

    RunwayCondition.standingWater : parameters.corrections.conditionFactorStandingWater,
    RunwayCondition.slush : parameters.corrections.conditionFactorSlush,

    RunwayCondition.wetSnow : parameters.corrections.conditionFactorWetSnow,
    RunwayCondition.drySnow : parameters.corrections.conditionFactorDrySnow,
  }[parameters.runwayCondition] ?? 1.0;

  ///Results in takeoff distance without safety margin!
  double calculateUnfactored(){
    var slopeFactor = _calculateSlopeFactor();
    var pressureFactor = _calculatePressureFactor();
    var tempFactor = _calculateTempFactor(calculatePressureAltitude());
    var windFactor = calculateWindFactor(calculateHeadwindComponent());

    var undergroundFactor = parameters.runway.surface == Surface.grass ? getUndergroundFactor() : 1.0;
    var sodDamagedFactor = getSodDamagedFactor();
    var highGrassFactor = getHighGrassFactor();

    var contaminationFactor = getContaminationFactor();

    var tod = parameters.rawTod * slopeFactor * pressureFactor * tempFactor * windFactor * undergroundFactor
        * sodDamagedFactor * highGrassFactor * contaminationFactor * 1.1;
    

     /*    print("rawTod: ${parameters.rawTod}, Slope: $slopeFactor, Pressure: $pressureFactor,"
     "Temp: $tempFactor, Wind: $windFactor, "
     "underGround: $undergroundFactor, sod: $sodDamagedFactor,"
     "highGrass: $highGrassFactor, contam: $contaminationFactor, * 1.1 = $tod");*/


    return tod;
  }
}

//json keys for Corrections
const _hwFieldValue = "headwindFac";
const _twFieldValue = "tailwindFac";

const _grassFirmFieldValue = "grassFirmFac";
const _grassWetFieldValue = "grassWetFac";
const _grassSoftFieldValue = "grassSoftFac";

const _sodDamagedFieldValue = "sodDamagedFac";
const _highGrassFieldValue = "highGrassFac";

const _condWetFieldValue = "wetFac";
const _condStandWaterFieldValue = "standingWaterFac";
const _condDrySnowFieldValue = "drySnowFac";
const _condSlushFieldValue = "slushFac";
const _condWetSnowFieldValue = "wetSnowFac";

///Used to bundle all correction values for the performance calculation
class Corrections{

  Corrections();

  ///Per 10 kts
  double headWindFactor = 1.1;
  ///Per 10 kts
  double tailWindFactor = 1.5;

  double grassFactorFirm = 1.2;
  double grassFactorWet = 1.3;
  double grassFactorSoftened = 2.0;

  double sodDamagedFactor = 1.1;
  double highGrassFactor = 1.2;

  double conditionFactorWet = 1.0;
  double conditionFactorStandingWater = 1.3;

  double conditionFactorSlush = 1.3;
  double conditionFactorWetSnow = 1.5;
  double conditionFactorDrySnow = 1.25;

  Corrections copy(){
    var cor = Corrections();

    cor.headWindFactor = headWindFactor;
    cor.tailWindFactor = tailWindFactor;

    cor.grassFactorFirm = grassFactorFirm;
    cor.grassFactorWet = grassFactorWet;
    cor.grassFactorSoftened = grassFactorSoftened;

    cor.sodDamagedFactor = sodDamagedFactor;
    cor.highGrassFactor = highGrassFactor;

    cor.conditionFactorWet = conditionFactorWet;
    cor.conditionFactorStandingWater = conditionFactorStandingWater;

    cor.conditionFactorSlush = conditionFactorSlush;
    cor.conditionFactorWetSnow = conditionFactorWetSnow;
    cor.conditionFactorDrySnow = conditionFactorDrySnow;

    return cor;
  }

  ///transform class into json representation
  Map<String, dynamic> serialize(){
    return {
      _hwFieldValue : headWindFactor,
      _twFieldValue : tailWindFactor,

      _grassFirmFieldValue : grassFactorFirm,
      _grassWetFieldValue : grassFactorWet,
      _grassSoftFieldValue : grassFactorSoftened,

      _sodDamagedFieldValue : sodDamagedFactor,
      _highGrassFieldValue : highGrassFactor,

      _condWetFieldValue : conditionFactorWet,
      _condStandWaterFieldValue : conditionFactorStandingWater,
      _condSlushFieldValue : conditionFactorSlush,
      _condWetSnowFieldValue : conditionFactorWetSnow,
      _condDrySnowFieldValue : conditionFactorDrySnow,

    };
  }

  ///transform json representation into dart class
  factory Corrections.deserialize({required Map<String, dynamic> map}){
    var cor = Corrections();

    cor.headWindFactor = map[_hwFieldValue] ?? cor.headWindFactor;
    cor.tailWindFactor = map[_twFieldValue] ?? cor.tailWindFactor;

    cor.grassFactorFirm = map[_grassFirmFieldValue] ?? cor.grassFactorFirm;
    cor.grassFactorWet = map[_grassWetFieldValue] ?? cor.grassFactorWet;
    cor.grassFactorSoftened = map[_grassSoftFieldValue] ?? cor.grassFactorSoftened;

    cor.sodDamagedFactor = map[_sodDamagedFieldValue] ?? cor.sodDamagedFactor;
    cor.highGrassFactor = map[_highGrassFieldValue] ?? cor.highGrassFactor;

    cor.conditionFactorWet = map[_condWetFieldValue] ?? cor.conditionFactorWet;
    cor.conditionFactorStandingWater = map[_condStandWaterFieldValue] ?? cor.conditionFactorStandingWater;

    cor.conditionFactorSlush = map[_condSlushFieldValue] ?? cor.conditionFactorSlush;
    cor.conditionFactorWetSnow = map[_condWetSnowFieldValue] ?? cor.conditionFactorWetSnow;
    cor.conditionFactorDrySnow = map[_condDrySnowFieldValue] ?? cor.conditionFactorDrySnow;

    return cor;
  }

  @override
  bool operator ==(Object other) {
    return other is Corrections
        && other.headWindFactor == headWindFactor
        && other.tailWindFactor == tailWindFactor
        && other.grassFactorFirm == grassFactorFirm
        && other.grassFactorWet == grassFactorWet
        && other.grassFactorSoftened == grassFactorSoftened
        && other.sodDamagedFactor == sodDamagedFactor
        && other.highGrassFactor == highGrassFactor
        && other.conditionFactorWet == conditionFactorWet
        && other.conditionFactorStandingWater == conditionFactorStandingWater
        && other.conditionFactorSlush == conditionFactorSlush
        && other.conditionFactorWetSnow == conditionFactorWetSnow
        && other.conditionFactorDrySnow == conditionFactorDrySnow;
  }

  @override
  int get hashCode => Object.hash(
      headWindFactor, tailWindFactor, grassFactorFirm,
      grassFactorWet, grassFactorSoftened, sodDamagedFactor, highGrassFactor,
      conditionFactorWet, conditionFactorStandingWater,
      conditionFactorSlush, conditionFactorWetSnow, conditionFactorDrySnow,
  );
}
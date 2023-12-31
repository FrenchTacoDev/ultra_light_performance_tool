import 'dart:math';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';

typedef Wind = ({int direction, int speed});

///Class that handles all the calculations
///Must be given all parameters on construction first.
///Then call the [calculateUnfactored] function to get a result without safety margin.
class PerformanceCalculator{

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

  const PerformanceCalculator({
    required this.corrections,
    required this.rawTod,
    required this.runway,
    required this.airport,
    required this.qnh,
    required this.temp,
    required this.wind,
    required this.underground,
    required this.highGrass,
    required this.sodDamaged,
    required this.runwayCondition,
  });

  ///Results in takeoff distance without safety margin!
  double calculateUnfactored(){
    var slopeFactor = (runway.slope / 10) + 1;

    var pa = 30 * (1013 - qnh) + airport.elevation;
    var pressureFactor = _calculateElevationCorrection(pa);

    var isaTemp = pa <= 0 ? 15 : 15 - ((pa / 1000) * 2);
    var currentTemp = temp < 0 ? 0 : temp;
    var deltaT = currentTemp - isaTemp;
    var tempFactor = deltaT >= 0 ? deltaT / 100 + 1 : 1 + deltaT / 100;

    var hwc = _getHeadwindComponent();
    var windFactor = hwc < 0 ? (hwc / 10).abs() * (corrections.tailWindFactor - 1) + 1 : 1 - (hwc / 10).abs() * (corrections.headWindFactor - 1);
    windFactor = windFactor < 0 ? 0 : windFactor;
    //Todo think about what makes sense when headwind is so strong that the tod is 0
    //Either 0 => all becomes 0 or 0.1 or 0.01 for a very small number

    //Todo enums should resolve from maps especially when implementing custom factors later on
    var undergroundFactor = 1.0;
    var sodDamagedFactor = 1.0;
    var highGrassFactor = 1.0;

    if(runway.surface == Surface.grass){
      if(underground == Underground.firm) undergroundFactor = corrections.grassFactorFirm;
      if(underground == Underground.wet) undergroundFactor = corrections.grassFactorWet;
      if(underground == Underground.softened) undergroundFactor = corrections.grassFactorSoftened;

      if(sodDamaged == true) sodDamagedFactor = corrections.sodDamagedFactor;
      if(highGrass == true) highGrassFactor = corrections.highGrassFactor;
    }

    var contaminationFactor = 1.0;
    if(runwayCondition == RunwayCondition.dry) contaminationFactor = 1.0;
    if(runwayCondition == RunwayCondition.wet) contaminationFactor = corrections.conditionFactorWet;

    if(runwayCondition == RunwayCondition.standingWater) contaminationFactor = corrections.conditionFactorStandingWater;
    if(runwayCondition == RunwayCondition.slush) contaminationFactor = corrections.conditionFactorSlush;

    if(runwayCondition == RunwayCondition.wetSnow) contaminationFactor = corrections.conditionFactorWetSnow;
    if(runwayCondition == RunwayCondition.drySnow) contaminationFactor = corrections.conditionFactorDrySnow;

    var tod = rawTod * slopeFactor * pressureFactor * tempFactor * windFactor * undergroundFactor
        * sodDamagedFactor * highGrassFactor * contaminationFactor * 1.1;


    /*
         print("rawTod: $rawTod, Slope: $slopeFactor, Pressure: $pressureFactor,"
     "Temp: $tempFactor, Wind: $windFactor, "
     "underGround: $undergroundFactor, sod: $sodDamagedFactor,"
     "highGrass: $highGrassFactor, contam: $contaminationFactor, * 1.1");
     */

    return tod;
  }

  double _calculateElevationCorrection(int pressureAlt){
    if(pressureAlt <= 0) return 1.0;
    if(pressureAlt <= 1000) return (pressureAlt / 1000) * (1 / 10) + 1;
    if(pressureAlt <= 3000) return (pressureAlt / 1000) * (13 / 100) + 1;
    return (pressureAlt / 1000) * (18 / 100) + 1;
  }

  double _getHeadwindComponent(){
    var angle = _getWindAngle();
    if(angle == 90) return 0.0;
    return wind.speed * cos((angle * pi) / 180);
  }

  double _getWindAngle(){
    var angularDiff = runway.direction - wind.direction;
    if(angularDiff % 360 == 180) return 180;
    if(angularDiff % 360 <= 180) return angularDiff % 180;
    return (wind.direction - runway.direction) % 180;
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
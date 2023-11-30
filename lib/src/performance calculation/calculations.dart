import 'dart:math';
import '../airports/airports.dart';

typedef Wind = ({int direction, int speed});

///Class that handles all the calculations
///Must be given all parameters on construction first.
///Then call the [calculateUnfactored] function to get a result without safety margin.
class PerformanceCalculator{

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

  ///results in takeoff distance without safety margin!
  double calculateUnfactored(){
    var slopeFactor = (runway.slope / 10) + 1;

    var pa = 30 * (1013 - qnh) + airport.elevation;
    var pressureFactor = _calculateElevationCorrection(pa);

    var isaTemp = pa <= 0 ? 15 : 15 - ((pa / 1000) * 2);
    var currentTemp = temp < 0 ? 0 : temp;
    var deltaT = currentTemp - isaTemp;
    var tempFactor = deltaT >= 0 ? deltaT / 100 + 1 : 1 + deltaT / 100;

    var hwc = _getHeadwindComponent();
    var hwCorrection = 10;
    var twCorrection = 25;
    var windFactor = hwc < 0 ? (hwc / 10).abs() * 2 * (twCorrection / 100) + 1 : 1 - (hwc / 10).abs() * (hwCorrection / 100);

    //Todo enums should resolve from maps especially when implementing custom factors later on
    var undergroundFactor = 1.0;
    var sodDamagedFactor = 1.0;
    var highGrassFactor = 1.0;

    if(runway.surface == Surface.grass){
      if(underground == Underground.firm) undergroundFactor = 1.2;
      if(underground == Underground.wet) undergroundFactor = 1.3;
      if(underground == Underground.softened) undergroundFactor = 2.0;

      if(sodDamaged == true) sodDamagedFactor = 1.1;
      if(highGrass == true) highGrassFactor = 1.2;
    }

    var contaminationFactor = 1.0;
    if(runwayCondition == RunwayCondition.dry) contaminationFactor = 1.0;
    if(runwayCondition == RunwayCondition.wet) contaminationFactor = 1.0;

    if(runwayCondition == RunwayCondition.standingWater) contaminationFactor = 1.3;
    if(runwayCondition == RunwayCondition.slush) contaminationFactor = 1.3;

    if(runwayCondition == RunwayCondition.wetSnow) contaminationFactor = 1.5;
    if(runwayCondition == RunwayCondition.drySnow) contaminationFactor = 1.25;

    var tod = rawTod * slopeFactor * pressureFactor * tempFactor * windFactor * undergroundFactor
        * sodDamagedFactor * highGrassFactor * contaminationFactor * 1.1;

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

  double conditionFactorDrySnow = 1.25;
  double conditionFactorSlush = 1.3;
  double conditionFactorWetSnow = 1.5;

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

    cor.conditionFactorDrySnow = conditionFactorDrySnow;
    cor.conditionFactorSlush = conditionFactorSlush;
    cor.conditionFactorWetSnow = conditionFactorWetSnow;

    return cor;
  }
}
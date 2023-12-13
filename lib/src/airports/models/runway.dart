import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Data representation of Runway
class Runway{

  static const String designatorFieldValue = "designator";
  static const String directionFieldValue = "direction";
  static const String surfaceFieldValue = "surface";
  static const String slopeFieldValue = "slope";
  static const String startElevationFieldValue = "startElevation";
  static const String endElevationFieldValue = "endElevation";
  static const String intersectFieldValue = "intersections";

  final String designator;
  ///[int] value between 0 and 360 degrees
  final int direction;
  final Surface surface;
  final double slope;
  ///Not used for slope calculation. Just to store the information. Slope calculation is done when adding a new runway within the cubit
  final int? startElevation;
  ///Not used for slope calculation. Just to store the information. Slope calculation is done when adding a new runway within the cubit
  final int? endElevation;
  ///List of all [Intersection]s contained. Represents sub parts of the runway.
  final List<Intersection> intersections;

  ///currently set fixed to 5.0.
  static double maxSlope = 5.0;
  ///currently set fixed to -5.0.
  static double minSlope = -5.0;

  ///[surface] standard is set to [Surface.asphalt]
  ///[slope] standard is set to 0.0
  Runway({
    required this.designator,
    required this.direction,
    required this.intersections,
    this.surface = Surface.asphalt,
    this.slope = 0.0,
    this.startElevation,
    this.endElevation,
  }) : assert(direction >= 0 && direction <= 360), assert(intersections.isNotEmpty);


  @override
  String toString() => designator;

  @override
  int get hashCode => Object.hash(designator, direction, slope, surface, intersections, startElevation, endElevation);

  @override
  bool operator ==(Object other) {
    return other is Runway
        && other.designator == designator
        && other.direction == direction
        && other.surface == surface
        && other.slope == slope
        && other.startElevation == startElevation
        && other.endElevation == endElevation
        && listEquals(other.intersections, intersections);
  }

  ///called to set slope by means of elevation and distance.
  double calculateSlope(int startElevation, int endElevation, int length) {
    return (((endElevation/3.2808) - (startElevation/3.2808)) / length) * 100;
  }

  ///transform class into json representation
  Future<Map<String, dynamic>> serialize() async{

    var intersectMaps = <Map<String, dynamic>>[];

    for(var intersect in intersections){
      intersectMaps.add(intersect.serialize());
      await Future.delayed(Duration.zero);
    }

    return {
      designatorFieldValue : designator,
      directionFieldValue : direction,
      surfaceFieldValue : surface.index,
      slopeFieldValue : slope,
      startElevationFieldValue : startElevation,
      endElevationFieldValue : endElevation,
      intersectFieldValue : intersectMaps,
    };
  }

  ///transform json representation into dart class
  static Future<Runway> deserialize({required Map<String, dynamic> map}) async{

    var intersects = <Intersection>[];
    for(var intersect in map[intersectFieldValue] ?? []){
      intersects.add(Intersection.deserialize(map: intersect));
      await Future.delayed(Duration.zero);
    }

    return Runway(
        designator: map[designatorFieldValue] ?? "Missing Designator",
        direction: map[directionFieldValue] ?? "Missing Direction",
        startElevation: map[startElevationFieldValue],
        endElevation: map[endElevationFieldValue],
        slope: map[slopeFieldValue],
        intersections: intersects,
        surface: map[surfaceFieldValue] != null ? Surface.values[map[surfaceFieldValue]!] : Surface.asphalt,
    );
  }
}

///Data representation of Intersection
class Intersection{

  static const String designatorFieldValue = "designator";
  static const String todFieldValue = "tod";

  final String designator;
  ///[int] value of takeoff distance available
  final int toda;

  const Intersection({required this.designator, required this.toda});

  @override
  String toString() => designator;

  @override
  int get hashCode => Object.hash(designator, toda);

  @override
  bool operator ==(Object other) {
    return other is Intersection
        && other.designator == designator
        && other.toda == toda;
  }

  ///transform json representation into dart class
  static Intersection deserialize({required Map<String, dynamic> map}) {
    return Intersection(
        designator: map[designatorFieldValue] ?? "Missing Designator",
        toda: map[todFieldValue] ?? 0
    );
  }

  ///transform class into json representation
  Map<String, dynamic> serialize() {
    return {
      designatorFieldValue : designator,
      todFieldValue : toda,
    };
  }
}

///Currently only asphalt and grass
enum Surface{
  asphalt, grass;
  toLocString(BuildContext context) => _surfaceMap[this]!(context);
}

final _surfaceMap = <Surface, String Function(BuildContext context)>{
  Surface.asphalt : (context) => Localizer.of(context).rwyAsphalt,
  Surface.grass : (context) => Localizer.of(context).rwyGrass,
};

///How grass is conditioned in case of grass runways. Currently considered as
///firm, wet and softened
enum Underground{
  firm, wet, softened;
  toLocString(BuildContext context) => _undergroundMap[this]!(context);
}

final _undergroundMap = <Underground, String Function(BuildContext context)>{
  Underground.firm : (context) => Localizer.of(context).firm,
  Underground.wet : (context) => Localizer.of(context).wet,
  Underground.softened : (context) => Localizer.of(context).softened,
};

///currently dry, wet, standing water, slush, wet snow and dry snow are considered
enum RunwayCondition{
  dry, wet, standingWater, slush, wetSnow, drySnow;
  toLocString(BuildContext context) => _rwyConditionMap[this]!(context);
}

final _rwyConditionMap = <RunwayCondition, String Function(BuildContext context)>{
  RunwayCondition.dry : (context) => Localizer.of(context).condDry,
  RunwayCondition.wet : (context) => Localizer.of(context).condWet,
  RunwayCondition.standingWater : (context) => Localizer.of(context).condStandingWater,
  RunwayCondition.slush : (context) => Localizer.of(context).condSlush,
  RunwayCondition.wetSnow : (context) => Localizer.of(context).condWetSnow,
  RunwayCondition.drySnow : (context) => Localizer.of(context).condDrySnow,
};
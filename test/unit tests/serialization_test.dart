import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';

void main() {
  test('Serialize and deserialize Intersections', () async {
    var json = jsonEncode(intersect.serialize());
    expect(json, '{"designator":"test1","tod":1325}');
    var map = jsonDecode(json);
    expect(Intersection.deserialize(map: map), intersect);
  });

  test('Serialize and deserialize Runways', () async {
    var json = jsonEncode(await runway.serialize());
    expect(json, '{"designator":"16L","direction":162,"surface":0,"slope":1.0,"startElevation":1050,'
        '"endElevation":1040,"intersections":[{"designator":"test1","tod":1325},{"designator":"test2","tod":1139}]}');
    var map = jsonDecode(json);
    expect(await Runway.deserialize(map: map), runway);
  });

  test("Serialize Airport", () async {
    var serialized = await testPort.serialize();
    expect(await Airport.deserialize(map: serialized), testPort);
  });
}

Intersection intersect = const Intersection(designator: "test1", toda: 1325);
Intersection intersect2 = const Intersection(designator: "test2", toda: 1139);
Intersection intersect3 = const Intersection(designator: "test3", toda: 2055);
Intersection intersect4 = const Intersection(designator: "test4", toda: 1930);

Runway runway = Runway(
    designator: "16L",
    direction: 162,
    startElevation: 1050,
    endElevation: 1040,
    slope: 1.0,
    intersections: [intersect, intersect2]
);
Runway runway2 = Runway(
    designator: "16R",
    direction: 162,
    startElevation: 1030,
    endElevation: 1030,
    slope: 0.0,
    intersections: [intersect3, intersect4]
);

Airport testPort = Airport(
    name: "Testport",
    icao: "TEST",
    runways: [runway, runway2],
    elevation: 1045,
);
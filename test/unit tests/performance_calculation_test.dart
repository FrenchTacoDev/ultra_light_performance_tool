import 'package:flutter_test/flutter_test.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';

void main(){
  test('Calculate TO Distance with default factors on asphalt runway', () async {

    var calc = PerformanceCalculator(
        corrections: Corrections(),
        rawTod: kiebitz.todr,
        runway: edfo.runways.first,
        airport: edfo,
        qnh: 1008,
        temp: 5,
        wind: (direction: 200, speed: 8),
        underground: Underground.firm,
        highGrass: false,
        sodDamaged: false,
        runwayCondition: RunwayCondition.dry
    );

    expect(calc.calculateUnfactored().ceil(), 371);

    calc = PerformanceCalculator(
        corrections: Corrections(),
        rawTod: kiebitz.todr,
        runway: edfo.runways[1],
        airport: edfo,
        qnh: 999,
        temp: 33,
        wind: (direction: 200, speed: 8),
        underground: Underground.firm,
        highGrass: false,
        sodDamaged: false,
        runwayCondition: RunwayCondition.wetSnow
    );

    expect(calc.calculateUnfactored().ceil(), 680);
  });

  test('Calculate TO Distance with default factors on grass runway', () async {
    //Todo implement
  });
}

const Aircraft kiebitz = Aircraft(name: "Kiebitz", todr: 280);
const Aircraft fk9 = Aircraft(name: "FK 9 MK IV", todr: 230);

final Airport edfo = Airport(
  name: "Michelstadt",
  icao: "EDFO",
  elevation: 1143,
  runways: [
    Runway(
        designator: "26",
        direction: 260,
        surface: Surface.asphalt,
        startElevation: 1113,
        endElevation: 1143,
        slope: 1.59,
        intersections: [
          const Intersection(
              designator: "Voll",
              toda: 574
          )
        ]
    ),
    Runway(
        designator: "08",
        direction: 80,
        surface: Surface.asphalt,
        startElevation: 1143,
        endElevation: 1113,
        slope: -1.59,
        intersections: [
          const Intersection(
              designator: "Voll",
              toda: 570
          )
        ]
    ),
  ],
);

final Airport edry = Airport(
  name: "Speyer",
  icao: "EDRY",
  elevation: 312,
  runways: [
    Runway(
        designator: "16 Grass",
        direction: 163,
        surface: Surface.grass,
        slope: 0,
        intersections: [
          const Intersection(
              designator: "Voll",
              toda: 480
          )
        ]
    ),
    Runway(
        designator: "34 Grass",
        direction: 343,
        surface: Surface.grass,
        intersections: [
          const Intersection(
              designator: "Voll",
              toda: 480
          )
        ]
    ),
  ],
);

final eddf = Airport(name: "Frankfurt Airport", icao: "EDDF", iata: "FRA", elevation: 364,
    runways: [
      Runway(
          designator: "25L",
          direction: 247,
          startElevation: 362,
          endElevation: 328,
          slope: -1.81,
          intersections: [
            const Intersection(designator: "Full", toda: 4000),
            const Intersection(designator: "M7/R5", toda: 3494),
          ]
      ),
      Runway(
          designator: "07R",
          direction: 067,
          startElevation: 328,
          endElevation: 362,
          slope: 1.81,
          intersections: [
            const Intersection(designator: "Full", toda: 4000),
            const Intersection(designator: "M25/R15", toda: 3085),
          ]
      )
    ]
);
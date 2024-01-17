import 'package:flutter_test/flutter_test.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';

void main(){
  test('Calculate TO Distance with default factors on asphalt runway', () async {

    var calc = PerformanceCalculator(
      parameters: CalculationParameters(
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
      )
    );

    print(calc.calculateUnfactored());
    expect(calc.calculateUnfactored().ceil(), 371);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: Corrections(),
          rawTod: kiebitz.todr,
          runway: edfo.runways[1],
          airport: edfo,
          qnh: 990,
          temp: -10,
          wind: (direction: 100, speed: 28),
          underground: Underground.firm,
          highGrass: false,
          sodDamaged: false,
          runwayCondition: RunwayCondition.slush
      )
    );

    expect(calc.calculateUnfactored().ceil(), 273);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
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
      )
    );

    expect(calc.calculateUnfactored().ceil(), 679);
  });

  test('Calculate TO Distance with default factors on grass runway', () async {
    var calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: Corrections(),
          rawTod: kiebitz.todr,
          runway: edry.runways.first,
          airport: edry,
          qnh: 1008,
          temp: 5,
          wind: (direction: 200, speed: 8),
          underground: Underground.firm,
          highGrass: true,
          sodDamaged: true,
          runwayCondition: RunwayCondition.dry
      )
    );

    expect(calc.calculateUnfactored().ceil(), 435);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: Corrections(),
          rawTod: kiebitz.todr,
          runway: edry.runways[1],
          airport: edry,
          qnh: 990,
          temp: -10,
          wind: (direction: 100, speed: 28),
          underground: Underground.softened,
          highGrass: false,
          sodDamaged: true,
          runwayCondition: RunwayCondition.wetSnow
      )
    );

    expect(calc.calculateUnfactored().ceil(), 1635);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: Corrections(),
          rawTod: kiebitz.todr,
          runway: edry.runways[1],
          airport: edry,
          qnh: 999,
          temp: 33,
          wind: (direction: 200, speed: 8),
          underground: Underground.softened,
          highGrass: false,
          sodDamaged: false,
          runwayCondition: RunwayCondition.wet
      )
    );

    expect(calc.calculateUnfactored().ceil(), 1043);
  });

  test('Calculate TO Distance with test factors on asphalt runway', () async {

    var calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: testCorrections,
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
      )
    );

    expect(calc.calculateUnfactored().ceil(), 232);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: testCorrections,
          rawTod: kiebitz.todr,
          runway: edfo.runways[1],
          airport: edfo,
          qnh: 990,
          temp: -10,
          wind: (direction: 100, speed: 28),
          underground: Underground.firm,
          highGrass: false,
          sodDamaged: false,
          runwayCondition: RunwayCondition.slush
      )
    );

    expect(calc.calculateUnfactored().ceil(), 0);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: testCorrections,
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
      )
    );

    expect(calc.calculateUnfactored().ceil(), 1684);
  });

  test('Calculate TO Distance with test factors factors on grass runway', () async {
    var calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: testCorrections,
          rawTod: kiebitz.todr,
          runway: edry.runways.first,
          airport: edry,
          qnh: 1008,
          temp: 5,
          wind: (direction: 200, speed: 8),
          underground: Underground.firm,
          highGrass: true,
          sodDamaged: true,
          runwayCondition: RunwayCondition.dry
      ),
    );

    expect(calc.calculateUnfactored().ceil(), 1513);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: testCorrections,
          rawTod: kiebitz.todr,
          runway: edry.runways[1],
          airport: edry,
          qnh: 990,
          temp: -10,
          wind: (direction: 100, speed: 28),
          underground: Underground.softened,
          highGrass: false,
          sodDamaged: true,
          runwayCondition: RunwayCondition.wetSnow
      )
    );

    expect(calc.calculateUnfactored().ceil(), 14052);

    calc = PerformanceCalculator(
      parameters: CalculationParameters(
          corrections: testCorrections,
          rawTod: kiebitz.todr,
          runway: edry.runways[1],
          airport: edry,
          qnh: 999,
          temp: 33,
          wind: (direction: 200, speed: 8),
          underground: Underground.softened,
          highGrass: false,
          sodDamaged: false,
          runwayCondition: RunwayCondition.wet
      )
    );

    expect(calc.calculateUnfactored().ceil(), 4358);
  });
}

final testCorrections = Corrections()
  ..headWindFactor = 2.0
  ..tailWindFactor = 2.1

  ..grassFactorFirm = 2.2
  ..grassFactorWet = 2.3
  ..grassFactorSoftened = 2.4
  ..highGrassFactor = 2.5
  ..sodDamagedFactor = 2.6

  ..conditionFactorWet = 2.7
  ..conditionFactorStandingWater = 2.8
  ..conditionFactorSlush = 2.9
  ..conditionFactorDrySnow = 3.0
  ..conditionFactorWetSnow = 3.1;

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
        slope: -1.60,
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
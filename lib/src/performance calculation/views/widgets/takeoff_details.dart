import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/models/runway.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/calculations.dart';

class TakeoffDetails extends StatelessWidget {
  const TakeoffDetails({
    super.key,
    required this.parameters,
    required this.safetyFactor,
    required this.intersection,
  });

  final CalculationParameters parameters;
  final double safetyFactor;
  final Intersection intersection;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    //var uTheme = theme.extensions[ULPTTheme] as ULPTTheme;
    var titleS = theme.textTheme.titleLarge;
    var bodyS = theme.textTheme.bodyLarge;
    var bodySB = bodyS!.merge(const TextStyle(fontWeight: FontWeight.bold));
    var calc = PerformanceCalculator(parameters: parameters);
    var pa = calc.calculatePressureAltitude();
    var isaDelta = calc.calculateIsaDelta(pa, parameters.temp).round();
    var hwc = calc.calculateHeadwindComponent();
    var facTod = calc.calculateUnfactored();

    return Scaffold(
      appBar: AppBar(title: const Text("Takeoff Details")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _BGCard(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: "Raw Takeoff Distance is ", style: titleS),
                          TextSpan(
                              text: "${parameters.rawTod}m",
                              style: titleS!.merge(const TextStyle(fontWeight: FontWeight.bold))
                          ),
                        ]
                    ),
                  )
              ),
              const SizedBox(height: 4,),
              _BGCard(
                  child: Column(
                    children: [
                      Text("Slope Correction", style: titleS,),
                      const SizedBox(height: 4,),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: "Slope: ", style: bodyS),
                              TextSpan(text: "${parameters.runway.slope}%", style: bodySB),
                            ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: "Slope Factor: ", style: bodyS),
                              TextSpan(text: calc.calculateSlopeFactor().toStringAsPrecision(3), style: bodySB),
                            ]
                        ),
                      ),
                    ],
                  )
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Elevation Correction", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Airfield Elevation: ", style: bodyS),
                            TextSpan(text: "${parameters.airport.elevation}ft", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Pressure Altitude: ", style: bodyS),
                            TextSpan(text: "${pa.ceil()}ft", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Elevation Factor: ", style: bodyS),
                            TextSpan(text: calc.calculatePressureFactor().toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Temperature Correction", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "OAT: ", style: bodyS),
                            TextSpan(text: "${parameters.temp}°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "ISA Temperature: ", style: bodyS),
                            TextSpan(text: "${calc.calculateIsaTemperature(pa).round()}°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "ISA Deviation: ", style: bodyS),
                            if(isaDelta == 0) TextSpan(text: "0°C", style: bodySB),
                            if(isaDelta < 0) TextSpan(text: "$isaDelta°C", style: bodySB),
                            if(isaDelta > 0) TextSpan(text: "+$isaDelta°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Temperature Factor: ", style: bodyS),
                            TextSpan(text: calc.calculateTempFactor(pa).toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.temp < 0) const SizedBox(height: 4,),
                    if(parameters.temp < 0) RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Hint: Temperatures below 0°C are not being corrected!", style: bodyS),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Wind Correction", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Wind: ", style: bodyS),
                            TextSpan(text: "${parameters.wind.direction}/${parameters.wind.speed}kt", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Wind Component: ", style: bodyS),
                            if(hwc < 0) TextSpan(text: "${-hwc}kt Tailwind", style: bodySB),
                            if(hwc >= 0) TextSpan(text: "${hwc}kt Headwind", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Wind Factor: ", style: bodyS),
                            TextSpan(text: calc.calculateWindFactor(hwc).toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              if(parameters.runway.surface == Surface.grass) const SizedBox(height: 4,),
              if(parameters.runway.surface == Surface.grass) _BGCard(
                child: Column(
                  children: [
                    Text("Grass Factors", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Grass Condition: ", style: bodyS),
                            TextSpan(text: "${parameters.underground?.toLocString(context) ?? "n.A."}", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Factor: ", style: bodyS),
                            TextSpan(text: calc.getUndergroundFactor().toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.sodDamaged) RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Sod Damaged Factor: ", style: bodyS),
                            TextSpan(text: parameters.corrections.sodDamagedFactor.toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.highGrass) RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "High Grass Factor: ", style: bodyS),
                            TextSpan(text: parameters.corrections.highGrassFactor.toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Runway Condition", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Runway Condition: ", style: bodyS),
                            TextSpan(text: "${parameters.runwayCondition.toLocString(context)}", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Condition Factor: ", style: bodyS),
                            TextSpan(text: calc.getContaminationFactor().toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      children: [
                        TextSpan(text: "The calculation contains a general factor of ", style: bodyS),
                        TextSpan(text: "1.10 (10%) ", style: bodySB),
                        TextSpan(text: "for moist air.", style: bodyS),
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Results", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Factorized Takeoff Distance Required: ", style: bodyS),
                            TextSpan(text: "${facTod.ceil()}m", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Margin Factor: ", style: bodyS),
                            TextSpan(text: "$safetyFactor", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Takeoff Distance Required with Margin: ", style: bodyS),
                            TextSpan(text: "${(facTod * safetyFactor).ceil()}m", style: bodySB),
                          ]
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Text("Runway 16L Full", style: titleS,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Takeoff Distance Available: ", style: bodyS),
                            TextSpan(text: "${intersection.toda}m", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Remaining Runway: ", style: bodyS),
                            TextSpan(text: "${(intersection.toda - (facTod * safetyFactor)).floor()}m (${(intersection.toda - facTod).floor()}m)", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
            ],
          ),
        )
    );
  }
}

class _BGCard extends StatelessWidget {
  const _BGCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}

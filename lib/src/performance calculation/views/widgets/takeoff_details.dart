import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/models/runway.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
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
    var hintS = theme.textTheme.bodySmall!.merge(const TextStyle(color: Colors.red));
    var bodySB = bodyS!.merge(const TextStyle(fontWeight: FontWeight.bold));
    var calc = PerformanceCalculator(parameters: parameters);
    var pa = calc.calculatePressureAltitude();
    var isaDelta = calc.calculateIsaDelta(pa, parameters.temp).round();
    var hwc = calc.calculateHeadwindComponent();
    var facTod = calc.calculateUnfactored();
    var intersectDesignator = intersection == parameters.runway.intersections.first ?
      Localizer.of(context).full : intersection.designator;

    return Scaffold(
      appBar: AppBar(title: Text(Localizer.of(context).tdHeading)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _BGCard(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: "${Localizer.of(context).tdRawDist} ", style: titleS),
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
                      Text(Localizer.of(context).tdSlopeCor, style: titleS,),
                      const SizedBox(height: 4,),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: "${Localizer.of(context).tdSlope}: ", style: bodyS),
                              TextSpan(text: "${parameters.runway.slope}%", style: bodySB),
                            ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: "${Localizer.of(context).tdSlopeFac}: ", style: bodyS),
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
                    Text(Localizer.of(context).tdElevCor, style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdAirfieldElev}: ", style: bodyS),
                            TextSpan(text: "${parameters.airport.elevation}ft", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdPA}: ", style: bodyS),
                            TextSpan(text: "${pa.ceil()}ft", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdElevFac}: ", style: bodyS),
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
                    Text(Localizer.of(context).tdElevCor, style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdOat}: ", style: bodyS),
                            TextSpan(text: "${parameters.temp}°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdIsa}: ", style: bodyS),
                            TextSpan(text: "${calc.calculateIsaTemperature(pa).round()}°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdIsaDev}: ", style: bodyS),
                            if(isaDelta == 0) TextSpan(text: "0°C", style: bodySB),
                            if(isaDelta < 0) TextSpan(text: "$isaDelta°C", style: bodySB),
                            if(isaDelta > 0) TextSpan(text: "+$isaDelta°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdTempFac}: ", style: bodyS),
                            TextSpan(text: calc.calculateTempFactor(pa).toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.temp < 0) const SizedBox(height: 4,),
                    if(parameters.temp < 0) RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children: [
                            TextSpan(text: Localizer.of(context).tdTempHint, style: hintS),
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
                    Text(Localizer.of(context).tdWindCor, style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdWind}: ", style: bodyS),
                            TextSpan(text: "${parameters.wind.direction}/${parameters.wind.speed}kt", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdWindComponent}: ", style: bodyS),
                            if(hwc < 0) TextSpan(text: "${-hwc.floor()}kt ${Localizer.of(context).tdTailWind}", style: bodySB),
                            if(hwc >= 0) TextSpan(text: "${hwc.floor()}kt ${Localizer.of(context).tdHeadWind}", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdWindFac}: ", style: bodyS),
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
                    Text(Localizer.of(context).tdGrassCor, style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdGrassCond}: ", style: bodyS),
                            TextSpan(text: "${parameters.underground?.toLocString(context) ?? "n.A."}", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).factor}: ", style: bodyS),
                            TextSpan(text: calc.getUndergroundFactor().toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.sodDamaged) RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdSodDamagedFac}: ", style: bodyS),
                            TextSpan(text: parameters.corrections.sodDamagedFactor.toStringAsPrecision(3), style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.highGrass) RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdHighGrassFac}: ", style: bodyS),
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
                    Text(Localizer.of(context).tdRwyCond, style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdRwyCond}: ", style: bodyS),
                            TextSpan(text: "${parameters.runwayCondition.toLocString(context)}", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdRwyFac}: ", style: bodyS),
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
                        TextSpan(text: Localizer.of(context).tdMoistAir1, style: bodyS),
                        TextSpan(text: " 1.10 (10%) ", style: bodySB),
                        TextSpan(text: Localizer.of(context).tdMoistAir2, style: bodyS),
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text(Localizer.of(context).tdResults, style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).pcTod}: ", style: bodyS),
                            TextSpan(text: "${facTod.ceil()}m", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdMarginFac}: ", style: bodyS),
                            TextSpan(text: "$safetyFactor", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).pcTodMargin}: ", style: bodyS),
                            TextSpan(text: "${(facTod * safetyFactor).ceil()}m", style: bodySB),
                          ]
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text("${Localizer.of(context).runway} ${parameters.runway.designator} $intersectDesignator", style: titleS,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).pcToda}: ", style: bodyS),
                            TextSpan(text: "${intersection.toda}m", style: bodySB),
                          ]
                      ),
                    ),
                    const SizedBox(height: 4,),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).pcRunwayRemain}\n", style: bodyS),
                            TextSpan(text: "${(intersection.toda - (facTod * safetyFactor)).floor()}m (${(intersection.toda - facTod).floor()}m)", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      Localizer.of(context).tdGeneralHint,
                      style: hintS,
                      textAlign: TextAlign.center,
                    ),
                  )
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

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

    var slopeFac = calc.calculateSlopeFactor();
    var pa = calc.calculatePressureAltitude();
    var pFac = calc.calculatePressureFactor();

    var isaDelta = calc.calculateIsaDelta(pa, parameters.temp).round();
    var tFac = calc.calculateTempFactor(pa);

    var hwc = PerformanceCalculator.calculateHeadwindComponent(wind: parameters.wind, rwyDir: parameters.runway.direction);
    var xwc = PerformanceCalculator.calculateCrosswindComponent(wind: parameters.wind, rwyDir: parameters.runway.direction);
    var windFac = calc.calculateWindFactor(hwc);

    var conFac = calc.getContaminationFactor();
    var ugFac = calc.getUndergroundFactor();
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
                      _CorrectionField(factor: slopeFac),
                      _FactorField(factor: slopeFac),
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
                    _CorrectionField(factor: pFac),
                    _FactorField(factor: pFac),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              _BGCard(
                child: Column(
                  children: [
                    Text(Localizer.of(context).tdTempCor, style: titleS,),
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
                    _CorrectionField(factor: tFac),
                    _FactorField(factor: tFac),
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
                            TextSpan(text: "${Localizer.of(context).tdCrosswindComponent}: ", style: bodyS),
                            if(xwc < 0) TextSpan(text: "${-xwc.floor()}kt L", style: bodySB),
                            if(xwc > 0) TextSpan(text: "${xwc.ceil()}kt R", style: bodySB),
                            if(xwc == 0) TextSpan(text: "${xwc.ceil()}kt", style: bodySB),
                          ]
                      ),
                    ),
                    _CorrectionField(factor: windFac),
                    _FactorField(factor: windFac),
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
                    _CorrectionField(factor: ugFac),
                    _FactorField(factor: ugFac),
                    if(parameters.sodDamaged) RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdSodDamaged}: ", style: bodyS),
                            TextSpan(text: "+${(parameters.corrections.sodDamagedFactor * 100 - 100).round()}% (${parameters.corrections.sodDamagedFactor.toStringAsFixed(2)})", style: bodySB),
                          ]
                      ),
                    ),
                    if(parameters.highGrass) RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${Localizer.of(context).tdHighGrass}: ", style: bodyS),
                            TextSpan(text: "+${(parameters.corrections.highGrassFactor * 100 - 100).round()}% (${parameters.corrections.highGrassFactor.toStringAsFixed(2)})", style: bodySB),
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
                    _CorrectionField(factor: conFac),
                    _FactorField(factor: conFac),
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
                        TextSpan(text: " 1.10 (+10%) ", style: bodySB),
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
                            TextSpan(text: "${Localizer.of(context).pcMarginTitle}: ", style: bodyS),
                            TextSpan(text: "+${(safetyFactor * 100 - 100).round()}% (${safetyFactor.toStringAsFixed(2)})", style: bodySB),
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

class _CorrectionField extends StatelessWidget {
  const _CorrectionField({required this.factor});

  final double factor;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var bodyS = theme.textTheme.bodyLarge;
    var bodySB = bodyS!.merge(const TextStyle(fontWeight: FontWeight.bold));

    return RichText(
      text: TextSpan(
          children: [
            TextSpan(text: "${Localizer.of(context).correction}: ", style: bodyS),
            TextSpan(text: "${factor > 1 ? "+" : ""}${(factor * 100 - 100).round()}%", style: bodySB),
          ]
      ),
    );
  }
}

class _FactorField extends StatelessWidget {
  const _FactorField({required this.factor});

  final double factor;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var bodyS = theme.textTheme.bodyLarge;
    var bodySB = bodyS!.merge(const TextStyle(fontWeight: FontWeight.bold));

    return RichText(
      text: TextSpan(
          children: [
            TextSpan(text: "${Localizer.of(context).factor}: ", style: bodyS),
            TextSpan(text: factor.toStringAsFixed(2), style: bodySB),
          ]
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

class TakeoffDetails extends StatelessWidget {
  const TakeoffDetails({super.key});

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var uTheme = theme.extensions[ULPTTheme] as ULPTTheme;
    var titleS = theme.textTheme.titleLarge;
    var bodyS = theme.textTheme.bodyLarge;
    var bodySB = bodyS!.merge(const TextStyle(fontWeight: FontWeight.bold));

    var hdgSt = Theme.of(context).textTheme.titleLarge!.merge(const TextStyle(color: Colors.white));
    const ts = TextStyle(color: Colors.white);

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
                              text: "250m",
                              style: titleS!.merge(const TextStyle(fontWeight: FontWeight.bold))
                          ),
                        ]
                    ),
                  )
              ),
              const SizedBox(height: 8,),
              _BGCard(
                  child: Column(
                    children: [
                      Text("Slope Correction", style: titleS,),
                      const SizedBox(height: 4,),
                      RichText(
                        text: TextSpan(
                            style: ts,
                            children: [
                              TextSpan(text: "Slope: ", style: bodyS),
                              TextSpan(text: "1.2%", style: bodySB),
                            ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: "Slope Factor: ", style: bodyS),
                              TextSpan(text: "1.12", style: bodySB),
                            ]
                        ),
                      ),
                    ],
                  )
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Elevation Correction", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Airfield Elevation: ", style: bodyS),
                            TextSpan(text: "1000ft", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Pressure Altitude: ", style: bodyS),
                            TextSpan(text: "1390ft", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Elevation Factor: ", style: bodyS),
                            TextSpan(text: "1.18", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Temperature Correction", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "OAT: ", style: bodyS),
                            TextSpan(text: "20°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "ISA Temperature: ", style: bodyS),
                            TextSpan(text: "13°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "ISA Deviation: ", style: bodyS),
                            TextSpan(text: "+7°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Temperature Factor: ", style: bodyS),
                            TextSpan(text: "1.07", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Wind Correction", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Wind: ", style: bodyS),
                            TextSpan(text: "220/15kt", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Wind Component: ", style: bodyS),
                            TextSpan(text: "10kt Headwind", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "ISA Deviation: ", style: bodyS),
                            TextSpan(text: "+7°C", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Wind Factor: ", style: bodyS),
                            TextSpan(text: "0.8", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Grass Factors", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Grass Factor Firm: ", style: bodyS),
                            TextSpan(text: "1.5", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Sod Damaged Factor: ", style: bodyS),
                            TextSpan(text: "1.4", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "High Grass Factor: ", style: bodyS),
                            TextSpan(text: "1.8", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Runway Condition", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Runway Condition: ", style: bodyS),
                            TextSpan(text: "Standing Water", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Condition Factor: ", style: bodyS),
                            TextSpan(text: "2.0", style: bodySB),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      children: [
                        TextSpan(text: "The calculation contains a general factor of ", style: bodyS),
                        TextSpan(text: "1.1 (10%) ", style: bodySB),
                        TextSpan(text: "for moist air.", style: bodyS),
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              _BGCard(
                child: Column(
                  children: [
                    Text("Results", style: titleS,),
                    const SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Factorized Takeoff Distance Required: ", style: bodyS),
                            TextSpan(text: "1325m", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Safety Margin: ", style: bodyS),
                            TextSpan(text: "1.15", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Takeoff Distance Required with Margin: ", style: bodyS),
                            TextSpan(text: "1523m", style: bodySB),
                          ]
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Text("Runway 16L Full", style: titleS,),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Takeoff Distance Available: ", style: bodyS),
                            TextSpan(text: "2000m", style: bodySB),
                          ]
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Remaining Runway: ", style: bodyS),
                            TextSpan(text: "477m (675m)", style: bodySB),
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
  const _BGCard({super.key, required this.child});

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

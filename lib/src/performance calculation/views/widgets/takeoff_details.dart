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
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "Wind: ",),
                      TextSpan(text: "220/15"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "Wind Component: ",),
                      TextSpan(text: "10kt Headwind"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "Wind Factor: ",),
                      TextSpan(text: "0.8"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "Grass Factor Firm: ",),
                      TextSpan(text: "1.5"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "Sod Damaged Factor: ",),
                      TextSpan(text: "1.5"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "High Grass Factor: ",),
                      TextSpan(text: "1.5"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "Contamination Factor Standing Water: ",),
                      TextSpan(text: "2.0"),
                    ]
                ),
              ),
              RichText(
                text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(text: "General Factor for moist air: ",),
                      TextSpan(text: "1.1"),
                    ]
                ),
              ),
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


//const Center(
//           child: Text("These are the takeoff details", style: TextStyle(color: Colors.white)),
//         )

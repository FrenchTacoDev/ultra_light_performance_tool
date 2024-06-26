import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/performance%20calculation/views/widgets/runway_graphic.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_tab_page.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Panel to show the calc results
class Results extends StatefulWidget {
  const Results({
    super.key,
    this.runway,
    this.intersection,
    this.rawTOD,
    this.factorizedTod,
    this.availTod,
    required this.isSmallSize
  });

  ///Runway to show on the graphic if selected
  final Runway? runway;
  ///Intersection to show on the graphic if selected
  final Intersection? intersection;
  ///raw takeoff distance without factor
  final int? rawTOD;
  ///takeoff distance factored
  final int? factorizedTod;
  ///available takeoff distance
  final int? availTod;
  ///used for screen size adjustment
  final bool isSmallSize;

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  bool showGraphic = false;

  @override
  Widget build(BuildContext context) {
    if(widget.rawTOD == null || widget.availTod == null || widget.runway == null || widget.intersection == null) return const _NoData();
    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              Localizer.of(context).showGraphic,
              style: TextStyle(color: theme.interactiveHintTextColor, fontSize: 16),
            ),
            Switch(
              activeColor: Colors.green,
              inactiveThumbColor: theme.interactiveHintTextColor,
              value: showGraphic,
              onChanged: (value) => setState(() {showGraphic = value;}),
            ),
          ],
        ),
        if(showGraphic == false) Expanded(child: _Data(tod: widget.rawTOD!, factorizedTod: widget.factorizedTod!, availTod: widget.availTod!, isSmallSize: widget.isSmallSize,)),
        if(showGraphic) Expanded(child: RunwayGraphic(runway: widget.runway!, intersection: widget.intersection!, rawTod: widget.rawTOD!, facTod: widget.factorizedTod!,)),
      ],
    );
  }
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) {
    return Text(
      Localizer.of(context).pcEnterData,
      style: TextStyle(
        fontSize: 40,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.tod,
    required this.factorizedTod,
    required this.availTod,
    required this.isSmallSize,
  });

  final int tod;
  final int factorizedTod;
  final int availTod;
  final bool isSmallSize;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extensions[ULPTTheme]! as ULPTTheme;

    var remainTod = availTod - factorizedTod;
    var remainTodUnfactored = availTod - tod;
    double fontSize = isSmallSize ? 16 : 20;
    double arrowSize = isSmallSize ? 20 : 40;

    if(isSmallSize){

      return ULPTTabPage(
        theme: theme.tabPageTheme,
        widgets: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${Localizer.of(context).pcToda}: ${availTod}m",
                style: TextStyle(
                  fontSize: fontSize,
                  color: remainTod >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                "${Localizer.of(context).pcTodMargin}: ${factorizedTod}m",
                style: TextStyle(
                    color: remainTod >= 0 ? Colors.green : Colors.redAccent,
                    fontSize: fontSize,
                ),
              ),
              const SizedBox(height: 4,),
              Icon(
                Icons.arrow_downward_rounded,
                size: arrowSize, color: remainTod >= 0 ? Colors.green : Colors.redAccent,
              ),
              Text(
                "${Localizer.of(context).pcRunwayRemain}: ${remainTod}m",
                style: TextStyle(
                    color: remainTod >= 0 ? Colors.green : Colors.redAccent,
                    fontSize: fontSize,
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${Localizer.of(context).pcToda}: ${availTod}m",
                style: TextStyle(
                  fontSize: fontSize,
                  color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                "${Localizer.of(context).pcTod}: ${tod}m",
                style: TextStyle(
                    color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                    fontSize: fontSize,
                ),
              ),
              const SizedBox(height: 4,),
              Icon(
                Icons.arrow_downward_rounded,
                size: arrowSize,
                color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
              ),
              Text(
                "${Localizer.of(context).pcRunwayRemain}: ${remainTodUnfactored}m",
                style: TextStyle(
                    color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                    fontSize: fontSize,
                ),
              )
            ],
          ),
        ],
      );

    }

    return ULPTTabPage(
        theme: theme.tabPageTheme,
        widgets: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${Localizer.of(context).pcToda}: ${availTod}m",
                style: TextStyle(
                  fontSize: fontSize,
                  color: remainTod >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${Localizer.of(context).pcTodMargin}: ${factorizedTod}m",
                    style: TextStyle(
                        color: remainTod >= 0 ? Colors.green : Colors.redAccent,
                        fontSize: fontSize,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Icon(
                    Icons.arrow_downward_rounded,
                    size: arrowSize, color: remainTod >= 0 ? Colors.green : Colors.redAccent,
                  ),
                  Text(
                    "${Localizer.of(context).pcRunwayRemain}: ${remainTod}m",
                    style: TextStyle(
                        color: remainTod >= 0 ? Colors.green : Colors.redAccent,
                        fontSize: fontSize,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${Localizer.of(context).pcToda}: ${availTod}m",
                style: TextStyle(
                  fontSize: fontSize,
                  color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${Localizer.of(context).pcTod}: ${tod}m",
                    style: TextStyle(
                        color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                        fontSize: fontSize,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Icon(
                    Icons.arrow_downward_rounded,
                    size: arrowSize,
                    color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                  ),
                  Text(
                    "${Localizer.of(context).pcRunwayRemain}: ${remainTodUnfactored}m",
                    style: TextStyle(
                        color: remainTodUnfactored >= 0 ? theme.interactiveHintTextColor : Colors.redAccent,
                        fontSize: fontSize,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
    );
  }
}



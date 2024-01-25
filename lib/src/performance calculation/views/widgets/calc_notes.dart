import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Widget that shows an overlay displaying the notes the user has entered for aircraft, airport,
///runway and intersection selected.
class CalculationNotes extends StatelessWidget {
  const CalculationNotes({
    super.key,
    this.aircraft,
    this.airport,
    this.runway,
    this.intersect,
  });

  final Aircraft? aircraft;
  final Airport? airport;
  final Runway? runway;
  final Intersection? intersect;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context).textTheme;
    var hdgTheme = theme.titleLarge;
    var notesTheme = theme.bodyLarge;

    return IntrinsicWidth(
      child: SimpleDialog(
        title: Center(child: Text(Localizer.of(context).notes,)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          if(aircraft?.notes != null) Text(Localizer.of(context).aircraft, style: hdgTheme,),
          if(aircraft?.notes != null) const SizedBox(height: 4,),
          if(aircraft?.notes != null) Text(aircraft!.notes!, style: notesTheme,),
          if(aircraft?.notes != null) const SizedBox(height: 16,),

          if(airport?.notes != null) Text("${Localizer.of(context).pcAPTitle} ${airport!.icao}", style: hdgTheme,),
          if(airport?.notes != null) const SizedBox(height: 4,),
          if(airport?.notes != null) Text(airport!.notes!, style: notesTheme,),
          if(airport?.notes != null) const SizedBox(height: 16,),

          if(runway?.notes != null) Text("${Localizer.of(context).runway} ${runway!.designator}", style: hdgTheme,),
          if(runway?.notes != null) const SizedBox(height: 4,),
          if(runway?.notes != null) Text(runway!.notes!, style: notesTheme,),
          if(runway?.notes != null) const SizedBox(height: 16,),

          if(intersect?.notes != null) Text(
            "${Localizer.of(context).intersection} ${(intersect == runway!.intersections.first ? Localizer.of(context).full : intersect!.designator)}",
            style: hdgTheme,
          ),
          if(intersect?.notes != null) const SizedBox(height: 4,),
          if(intersect?.notes != null) Text(intersect!.notes!, style: notesTheme,),
          if(intersect?.notes != null) const SizedBox(height: 16,),
        ],
      ),
    );
  }
}

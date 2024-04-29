import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/utils/extensions.dart';
import 'package:ultra_light_performance_tool/ulpt.dart';

class RunwayGraphic extends StatelessWidget {
  const RunwayGraphic({super.key, required this.runway, required this.intersection, required this.rawTod, required this.facTod});

  final Runway runway;
  final Intersection intersection;
  final int rawTod;
  final int facTod;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: RunwayGraphicPainter(
          uTheme: Theme.of(context).extensions[ULPTTheme]! as ULPTTheme,
          runway: runway,
          intersection: intersection,
          facTod: facTod,
          rawTod: rawTod,
        ),
        size: const Size(double.infinity, double.infinity),
      ),
    );
  }
}

class RunwayGraphicPainter extends CustomPainter{

  RunwayGraphicPainter({
    required this.uTheme,
    required this.runway,
    required this.intersection,
    required this.rawTod,
    required this.facTod
  });

  final ULPTTheme uTheme;
  final Runway runway;
  final Intersection intersection;
  final int rawTod;
  final int facTod;

  final double topTextAreaHeight = 22;
  final double aftTextAreaWidth = 40;
  final double mainTextSize = 16;
  final double labelTextSize = 12;
  final double maxHeight = 100;
  final double runwayHeight = 100;

  @override
  void paint(Canvas canvas, Size size) {
    var runwayStartPoint = Offset(0, runwayHeight / 2 + topTextAreaHeight);
    var runwayEndPoint = Offset(size.width - aftTextAreaWidth, runwayHeight / 2 + topTextAreaHeight);

    //How many percent of the runway toda are we further into the runway?
    var intersectXDif =
        (runway.intersections.first.toda - intersection.toda) / runway.intersections.first.toda;
    //Translate this into pixels
    var intersectX = runwayStartPoint.dx + intersectXDif * (runwayEndPoint.dx - runwayStartPoint.dx);

    paintRunway(canvas, runwayStartPoint, runwayEndPoint);
    paintRunwayLines(canvas, runwayStartPoint, runwayEndPoint, intersectX);
    if(facTod <= intersection.toda) paintFacTod(canvas, runwayStartPoint, runwayEndPoint, intersectX);
    if(rawTod <= intersection.toda) paintRawTod(canvas, runwayStartPoint, runwayEndPoint, intersectX);
    paintLabels(canvas, runwayStartPoint, runwayEndPoint, intersectX);
  }

  void paintRunway(Canvas canvas, Offset runwayStart, Offset runwayEnd){
    var paint = Paint();
    paint.color = Colors.black;
    var runway = Rect.fromLTWH(runwayStart.dx, runwayStart.dy - runwayHeight / 2, runwayEnd.dx - runwayStart.dx, runwayHeight);
    canvas.drawRect(runway, paint);
  }

  void paintRunwayLines(Canvas canvas, Offset runwayStart, Offset runwayEnd, double intersectX){
    var paint = Paint();
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    //Draw End Line
    canvas.drawLine(
        Offset(runwayEnd.dx, runwayEnd.dy - runwayHeight / 2 + 2),
        Offset(runwayEnd.dx, runwayEnd.dy + runwayHeight / 2 - 2),
        paint
    );

    canvas.drawLine(
        Offset(intersectX, runwayStart.dy - runwayHeight / 2 + 2),
        Offset(intersectX, runwayStart.dy + runwayHeight / 2 - 2),
        paint
    );
  }

  void paintLabels(Canvas canvas, Offset runwayStartPoint, Offset runwayEndPoint, double intersectX){

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    //Numbers
    var numbersStyle = TextStyle(fontSize: mainTextSize, color: Colors.white, fontWeight: FontWeight.bold);
    textPainter.text = TextSpan(text: runway.designator, style: numbersStyle);
    textPainter.layout();

    var paint = Paint();
    paint.color = Colors.black;
    var numbersBase = Offset(runwayStartPoint.dx + mainTextSize / 2 + 8, runwayStartPoint.dy);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(numbersBase.dx, numbersBase.dy),
            width: mainTextSize,
            height: textPainter.width + 4
        ),
        paint
    );

    canvas.drawRotatedText(textPainter: textPainter, angle: 90, pivot: numbersBase);

    //Intx Label
    var labelStyle = TextStyle(fontSize: labelTextSize, color: Colors.white);
    textPainter.text = TextSpan(text: intersection.designator, style: labelStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(intersectX, 0));

    textPainter.text = TextSpan(text: "TODA", style: labelStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(runwayEndPoint.dx + 8, runwayEndPoint.dy - textPainter.height / 2));
  }

  void paintFacTod(Canvas canvas, Offset runwayStart, Offset runwayEnd, double intersectX){
    //Paint the tod
    var p = facTod / intersection.toda;
    var x = intersectX + (runwayEnd.dx - intersectX) * p;
    var y = runwayEnd.dy - runwayHeight / 5;

    var paint = Paint();
    paint.color = Colors.green;
    canvas.drawLine(Offset(intersectX, y), Offset(x, y), paint);
    //Paint the Cap
    paint.strokeWidth = 3;
    canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), paint);
  }

  void paintRawTod(Canvas canvas, Offset runwayStart, Offset runwayEnd, double intersectX){
    //Paint the tod
    var p = rawTod / intersection.toda;
    var x = intersectX + (runwayEnd.dx - intersectX) * p;
    var y = facTod <= intersection.toda ? runwayEnd.dy + runwayHeight / 5 : runwayEnd.dy;

    var paint = Paint();
    facTod <= intersection.toda ? paint.color = Colors.cyan : Colors.green;
    canvas.drawLine(Offset(intersectX, y), Offset(x, y), paint);
    //Paint the Cap
    paint.strokeWidth = 3;
    canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
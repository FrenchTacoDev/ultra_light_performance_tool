import 'dart:math' as math;
import 'package:flutter/painting.dart';

//Copyright by tarakparab https://gist.github.com/tarakparab
extension RotatedTextExt on Canvas {
  /// [angle] is in radians. Set `isInDegrees = true` if it is in degrees.
  void drawRotatedText({
    required Offset pivot,
    required TextPainter textPainter,
    TextPainter? superTextPainter,
    TextPainter? subTextPainter,
    required double angle,
    Alignment alignment = Alignment.center,
  }) {
    var angleRad = angle * math.pi / 180;
    textPainter.layout();
    superTextPainter?.layout();
    subTextPainter?.layout();

    // Calculate delta. Delta is the top left offset with reference
    // to which the main text will paint. The centre of the text will be
    // at the given pivot unless [alignment] is set.
    final w = textPainter.width;
    final h = textPainter.height;
    final delta = pivot.translate(-w / 2 + w / 2 * alignment.x, -h / 2 + h / 2 * alignment.y);
    final supDelta = delta.translate(w, h - h * 0.6 - (superTextPainter?.size.height ?? 0));
    final subDelta = delta.translate(w, h - (subTextPainter?.size.height ?? 0));

    // Rotate the text about pivot
    save();
    translate(pivot.dx, pivot.dy);
    rotate(angleRad);
    translate(-pivot.dx, -pivot.dy);
    textPainter.paint(this, delta);
    superTextPainter?.paint(this, supDelta);
    subTextPainter?.paint(this, subDelta);
    restore();
  }
}
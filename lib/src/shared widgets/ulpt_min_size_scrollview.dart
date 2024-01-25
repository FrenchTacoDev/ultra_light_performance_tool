import 'dart:math';
import 'package:flutter/material.dart';

///Imposes a constraint that either uses the screen size or the minimum height given, whichever is greater.
///If [minHeight] is greater than the screen size, widget is scrollable
class ULPTMinSizeScrollView extends StatelessWidget {
  const ULPTMinSizeScrollView({
    super.key,
    required this.minHeight,
    required this.child,
    this.scrollController,
  });

  final double minHeight;
  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints)
      => SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          height: max(constraints.maxHeight, minHeight),
          child: child,
        ),
      ),
    );
  }
}

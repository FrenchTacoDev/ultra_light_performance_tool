import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

class DesignatorEntry extends StatefulWidget {
  const DesignatorEntry({
    super.key,
    required this.onDesignatorSet,
    this.value,
    this.isIntersect = false,
  });

  ///[String] value that will fill the field if set
  final String? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<String?> onDesignatorSet;
  ///if true handles naming logic for intersections
  final bool isIntersect;

  @override
  State<DesignatorEntry> createState() => _DesignatorEntryState();
}

class _DesignatorEntryState extends State<DesignatorEntry>{

  final TextEditingController tec = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChanged);
  }

  @override
  void dispose() {
    tec.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onFocusChanged(){
    if(focusNode.hasFocus == false) onSubmitted();
  }

  void onSubmitted(){
    if(tec.value.text.isEmpty) return widget.onDesignatorSet(null);
    widget.onDesignatorSet(tec.text);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      hintText: widget.isIntersect ? Localizer.of(context).rwyIntersectNameHint
          : Localizer.of(context).rwyNameHint,
    );
  }

  void _insertValue(){
    var valueText = widget.value ?? "";
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );
  }
}



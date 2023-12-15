import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';

///Text entry to add aircraft takeoff-distance.
class ACTodEntry extends StatefulWidget {
  const ACTodEntry({
    super.key,
    required this.onTodSet,
    this.value
  });

  ///[int] value that will fill the field if set
  final int? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onTodSet;

  @override
  State<ACTodEntry> createState() => _ACTodEntryState();
}

class _ACTodEntryState extends State<ACTodEntry>{

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
    if(tec.value.text.isEmpty) return widget.onTodSet(null);

    String valueText = tec.text;

    if(tec.text.contains("m")) valueText = tec.text.split("m").first;
    if(valueText.contains("m")) valueText = "";
    if(valueText.isEmpty) return widget.onTodSet(null);

    var value = int.tryParse(valueText);

    if(value != null) valueText = "${value}m";

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length - 1, extentOffset: valueText.length - 1),
        composing: TextRange.empty
    );

    widget.onTodSet(value);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      isOnlyNumbers: true,
      hintText: Localizer.of(context).addACTodHint,
      inputFormatter: _TodInputFormatter(),
    );
  }

  void _insertValue(){
    var valueText = widget.value == null ? "" : "${widget.value}m";
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(
            baseOffset: valueText.isEmpty ? valueText.length : valueText.length - 1,
            extentOffset: valueText.isEmpty ? valueText.length : valueText.length - 1,
        ),
        composing: TextRange.empty
    );
  }
}

class _TodInputFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) {
      return newValue.copyWith(
        text: newValue.text,
          selection: TextSelection(
              baseOffset: newValue.text.contains("m") ? newValue.text.length - 1 : newValue.text.length,
              extentOffset: newValue.text.contains("m") ? newValue.text.length - 1 : newValue.text.length,
          ),
          composing: TextRange.empty
      );
    }
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(
          baseOffset: corrected.contains("m") ? corrected.length - 1 : corrected.length,
          extentOffset: corrected.contains("m") ? corrected.length - 1 : corrected.length,
        ),
        composing: TextRange.empty
    );
  }
}
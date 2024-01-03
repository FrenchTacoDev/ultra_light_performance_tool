import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to set the runway slope.
class RunwaySlopeEntry extends StatefulWidget {
  const RunwaySlopeEntry({
    super.key,
    required this.onSlopeSet,
    this.value,
  });

  ///[double] value that will fill the field if set
  final double? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<double?> onSlopeSet;

  @override
  State<RunwaySlopeEntry> createState() => _RunwaySlopeEntryState();
}

class _RunwaySlopeEntryState extends State<RunwaySlopeEntry>{

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
    if(tec.value.text.isEmpty) return widget.onSlopeSet(null);

    String valueText = tec.text;

    if(tec.text.contains("%")) valueText = tec.text.split("%").first;
    if(valueText.contains("%")) valueText = "";
    if(valueText.isEmpty) return widget.onSlopeSet(null);

    var value = double.tryParse(valueText);

    if(value != null) valueText = "$value%";

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length - 1, extentOffset: valueText.length - 1),
        composing: TextRange.empty
    );

    widget.onSlopeSet(value);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      isOnlyNumbers: true,
      hintText: Localizer.of(context).rwySlopeHint,
      inputFormatter: _ElevFormatter(),
    );
  }

  void _insertValue(){
    var valueText = widget.value == null ? "" : "${widget.value}%";
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

class _ElevFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) {
      return newValue.copyWith(
          text: newValue.text,
          selection: TextSelection(
            baseOffset: newValue.text.contains("%") ? newValue.text.length - 1 : newValue.text.length,
            extentOffset: newValue.text.contains("%") ? newValue.text.length - 1 : newValue.text.length,
          ),
          composing: TextRange.empty
      );
    }
    if(RegExp(r'^$|^(-?\d+(\.\d*)?|-\s?)\s*%?$').hasMatch(newValue.text) == false) return oldValue;
    return newValue.copyWith(
        text: newValue.text,
        selection: TextSelection(
          baseOffset: newValue.text.contains("%") ? newValue.text.length - 1 : newValue.text.length,
          extentOffset: newValue.text.contains("%") ? newValue.text.length - 1 : newValue.text.length,
        ),
        composing: TextRange.empty
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to add airport elevation.
class ElevationEntry extends StatefulWidget {
  const ElevationEntry({
    super.key,
    required this.onElevationSet,
    this.value
  });

  ///[int] value that will fill the field if set
  final int? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onElevationSet;

  @override
  State<ElevationEntry> createState() => _ElevationEntryState();
}

class _ElevationEntryState extends State<ElevationEntry>{

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
    if(tec.value.text.isEmpty) return widget.onElevationSet(null);

    String valueText = tec.text;

    if(tec.text.contains("ft")) valueText = tec.text.split("ft").first;
    if(valueText.contains("ft")) valueText = "";
    if(valueText.isEmpty) return widget.onElevationSet(null);

    var value = int.tryParse(valueText);

    if(value != null) valueText = "${value}ft";

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length - 1, extentOffset: valueText.length - 1),
        composing: TextRange.empty
    );

    widget.onElevationSet(value);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      isOnlyNumbers: true,
      hintText: Localizer.of(context).apElevHint,
      inputFormatter: _ElevFormatter(),
    );
  }

  void _insertValue(){
    var valueText = widget.value == null ? "" : "${widget.value}ft";
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(
          baseOffset: valueText.isEmpty ? valueText.length : valueText.length - 2,
          extentOffset: valueText.isEmpty ? valueText.length : valueText.length - 2,
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
            baseOffset: newValue.text.contains("ft") ? newValue.text.length - 2 : newValue.text.length,
            extentOffset: newValue.text.contains("ft") ? newValue.text.length - 2 : newValue.text.length,
          ),
          composing: TextRange.empty
      );
    }
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(
          baseOffset: corrected.contains("ft") ? corrected.length - 2 : corrected.length,
          extentOffset: corrected.contains("ft") ? corrected.length - 2 : corrected.length,
        ),
        composing: TextRange.empty
    );
  }
}
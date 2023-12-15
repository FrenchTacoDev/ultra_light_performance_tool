import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to set runway elevation.
class RunwayElevationEntry extends StatefulWidget {
  const RunwayElevationEntry({
    super.key,
    required this.onElevationSet,
    this.value,
    this.endElev = false,
  });

  ///[int] value that will fill the field if set
  final int? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onElevationSet;
  ///if true handles internal setting for runway end elevation
  final bool endElev;

  @override
  State<RunwayElevationEntry> createState() => _RunwayElevationEntryState();
}

class _RunwayElevationEntryState extends State<RunwayElevationEntry>{

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
      hintText: widget.endElev ? Localizer.of(context).rwyEndElevHint : Localizer.of(context).rwyStartElevHint,
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
    if(RegExp(r'^$|^(-?\d+)(?:\s*ft)?$').hasMatch(newValue.text) == false) return oldValue;
    return newValue.copyWith(
        text: newValue.text,
        selection: TextSelection(
          baseOffset: newValue.text.contains("ft") ? newValue.text.length - 2 : newValue.text.length,
          extentOffset: newValue.text.contains("ft") ? newValue.text.length - 2 : newValue.text.length,
        ),
        composing: TextRange.empty
    );
  }
}
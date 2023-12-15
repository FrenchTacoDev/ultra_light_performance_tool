import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to add airport iata code.
///IATA code is supposed to be a 3-letter code
class IataEntry extends StatefulWidget {
  const IataEntry({
    super.key,
    required this.onIataSet,
    this.value
  });

  ///[String] value that will fill the field if set
  final String? value;
  ///[onIataSet] callback function that is called when field is submitted or looses focus
  final ValueSetter<String?> onIataSet;

  @override
  State<IataEntry> createState() => _IataEntryState();
}

class _IataEntryState extends State<IataEntry>{

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
    if(tec.value.text.isEmpty) return widget.onIataSet(null);
    widget.onIataSet(tec.text);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      hintText: Localizer.of(context).apIataHint,
      inputFormatter: _IcaoInputFormatter(),
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

class _IcaoInputFormatter extends TextInputFormatter{

  final String iataRegex = r"(^[A-Za-z]{0,3}$)";
  bool isValidICAOCode(String? icao) => icao == null || RegExp(iataRegex).hasMatch(icao);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(isValidICAOCode(newValue.text)) return newValue.copyWith(text: newValue.text.toUpperCase());
    return oldValue;
  }
}



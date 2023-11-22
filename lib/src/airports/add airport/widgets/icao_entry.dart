import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';

///Text entry to add airport icao code.
///ICAO code is supposed to be a 4-letter code
class IcaoEntry extends StatefulWidget {
  const IcaoEntry({
    super.key,
    required this.onIcaoSet,
    this.value
  });

  ///[String] value that will fill the field if set
  final String? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<String?> onIcaoSet;

  @override
  State<IcaoEntry> createState() => _IcaoEntryState();
}

class _IcaoEntryState extends State<IcaoEntry>{

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
    if(tec.value.text.isEmpty) return widget.onIcaoSet(null);
    widget.onIcaoSet(tec.text);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      hintText: "ICAO Code",
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

  final String icaoRegex = r"(^[A-Za-z0-9]{0,2}[-]?\d{0,4}$)|(^[A-Za-z]{0,3}$)|(^[a-zA-Z0-9]{0,4}$)";
  bool isValidICAOCode(String? icao) => icao == null || RegExp(icaoRegex).hasMatch(icao);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(isValidICAOCode(newValue.text)) return newValue.copyWith(text: newValue.text.toUpperCase());
    return oldValue;

    //    if(newValue.text.isEmpty) return newValue;
    //     if(newValue.text.length < oldValue.text.length) {
    //       return newValue.copyWith(
    //           text: newValue.text,
    //           selection: TextSelection(
    //             baseOffset: newValue.text.contains("m") ? newValue.text.length - 1 : newValue.text.length,
    //             extentOffset: newValue.text.contains("m") ? newValue.text.length - 1 : newValue.text.length,
    //           ),
    //           composing: TextRange.empty
    //       );
    //     }
    //     var corrected = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");
    //     return newValue.copyWith(
    //         text: corrected,
    //         selection: TextSelection(
    //           baseOffset: corrected.contains("m") ? corrected.length - 1 : corrected.length,
    //           extentOffset: corrected.contains("m") ? corrected.length - 1 : corrected.length,
    //         ),
    //         composing: TextRange.empty
    //     );
  }
}



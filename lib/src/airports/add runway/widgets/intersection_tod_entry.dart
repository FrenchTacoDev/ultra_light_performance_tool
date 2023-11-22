import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';

///Text entry to add takeoff-distance for intersections.
class IntersectionTodEntry extends StatefulWidget {
  const IntersectionTodEntry({
    super.key,
    required this.onTodSet,
    this.value,
    this.maxValue
  });

  ///[int] value that will fill the field if set
  final int? value;
  ///restrict the value according to input.
  final int? maxValue;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onTodSet;

  @override
  State<IntersectionTodEntry> createState() => _IntersectionTodEntryState();
}

class _IntersectionTodEntryState extends State<IntersectionTodEntry>{

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
    valueText = "${value ?? 0}m";

    //Todo check for maxvalue
    //    if(value != null && (value < 0 || value > 360)){
    //       _showCourseErrorDialog();
    //       value = null;
    //     }else{
    //       valueText = _courseToString(value ?? 0);
    //     }

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
      hintText: "Verfügbare Startdistanz",
      isOnlyNumbers: true,
      inputFormatter: _ElevFormatter(),
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

  //Todo change to maxTODDialog
  _showCourseErrorDialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ungültiger Kurs", textAlign: TextAlign.center,),
        content: const Text("Der Kurs muss zwischen 0 und 360° liegen!", textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
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
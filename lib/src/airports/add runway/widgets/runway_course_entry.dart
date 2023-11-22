import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';

///Text entry to set runway course.
class RunwayCourseEntry extends StatefulWidget {
  const RunwayCourseEntry({
    super.key,
    required this.onCourseSet,
    this.value
  });

  ///[int] value between 0 and 360 degrees that will fill the field if set
  final int? value;
  ///[onCourseSet] callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onCourseSet;

  @override
  State<RunwayCourseEntry> createState() => _RunwayCourseEntryState();
}

class _RunwayCourseEntryState extends State<RunwayCourseEntry>{

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
    if(tec.value.text.isEmpty) return widget.onCourseSet(null);

    String valueText = tec.text;

    if(tec.text.contains("°")) valueText = tec.text.split("°").first;
    if(valueText.contains("°")) valueText = "";
    if(valueText.isEmpty) return widget.onCourseSet(null);

    var value = int.tryParse(valueText);

    if(value != null && (value < 0 || value > 360)){
      _showCourseErrorDialog();
      value = null;
    }else{
      valueText = _courseToString(value ?? 0);
    }

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length - 1, extentOffset: valueText.length - 1),
        composing: TextRange.empty
    );

    widget.onCourseSet(value);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      isOnlyNumbers: true,
      hintText: "Pistenausrichtung in Grad",
      inputFormatter: _ElevFormatter(),
    );
  }

  void _insertValue(){
    var valueText = widget.value == null ? "" : _courseToString(widget.value!);
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(
          baseOffset: valueText.isEmpty ? valueText.length : valueText.length - 1,
          extentOffset: valueText.isEmpty ? valueText.length : valueText.length - 1,
        ),
        composing: TextRange.empty
    );
  }

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

  String _courseToString(int course){
    assert(course >= 0 && course <= 360);
    if(course > 99) return "$course°";
    if(course > 9) return "0$course°";
    return "00$course°";
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
            baseOffset: newValue.text.contains("°") ? newValue.text.length - 1 : newValue.text.length,
            extentOffset: newValue.text.contains("°") ? newValue.text.length - 1 : newValue.text.length,
          ),
          composing: TextRange.empty
      );
    }
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(
          baseOffset: corrected.contains("°") ? corrected.length - 1 : corrected.length,
          extentOffset: corrected.contains("°") ? corrected.length - 1 : corrected.length,
        ),
        composing: TextRange.empty
    );
  }
}
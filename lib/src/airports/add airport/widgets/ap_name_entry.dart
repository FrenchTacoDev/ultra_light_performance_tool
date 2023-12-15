import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to add airport name.
class APNameEntry extends StatefulWidget {
  const APNameEntry({
    super.key,
    required this.onNameSet,
    this.value
  });

  ///[String] value that will fill the field if set
  final String? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<String?> onNameSet;

  @override
  State<APNameEntry> createState() => _APNameEntryState();
}

class _APNameEntryState extends State<APNameEntry>{

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
    if(tec.value.text.isEmpty) return widget.onNameSet(null);
    widget.onNameSet(tec.text);
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      hintText: Localizer.of(context).apNameHint,
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



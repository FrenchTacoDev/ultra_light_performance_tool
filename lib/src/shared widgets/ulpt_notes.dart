import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'package:ultra_light_performance_tool/src/shared widgets/ulpt_textfield.dart';

///Text entry to add notes to any model.
///Will impose multi line insert behaviour on the textfield
class NotesEntry extends StatefulWidget {
  const NotesEntry({
    super.key,
    required this.onNotesSet,
    this.value
  });

  ///[String] value that will fill the field if set
  final String? value;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<String?> onNotesSet;

  @override
  State<NotesEntry> createState() => _NotesEntryState();
}

class _NotesEntryState extends State<NotesEntry>{

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
    widget.onNotesSet(tec.text.isEmpty ? null : tec.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    _insertValue();
    return ULPTTextField(
      focusNode: focusNode,
      tec: tec,
      hintText: Localizer.of(context).notes,
      forceMultiLine: true,
    );
  }

  void _insertValue(){
    var valueText = widget.value ?? "";
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
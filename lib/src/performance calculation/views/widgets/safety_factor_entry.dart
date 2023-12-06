import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_textfield.dart';

///Text entry to add and adjust the safety factor.
class SafetyFactorEntryField extends StatefulWidget {
  const SafetyFactorEntryField({
    Key? key,
    required this.onFactorSet,
    this.value,
    this.maxValue = 1000,
    this.isSmallSize = false,
  }) : super(key: key);

  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onFactorSet;
  ///maximum value that is set if given value is higher
  final int maxValue;
  ///the current value
  final int? value;
  ///used for screen size adjustment
  final bool isSmallSize;

  @override
  State<SafetyFactorEntryField> createState() => _SafetyFactorEntryFieldState();
}

class _SafetyFactorEntryFieldState extends State<SafetyFactorEntryField> {

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
    if(focusNode.hasFocus) {
      widget.onFactorSet(null);
      tec.value = tec.value.copyWith(
          text: "",
          selection: const TextSelection(baseOffset: 0, extentOffset: 0),
          composing: TextRange.empty
      );
      return;
    }
    
    onSubmitted();
  }

  void onSubmitted(){
    if(tec.value.text.isEmpty) return;

    String valueText = "";
    var value = int.tryParse(tec.value.text);

    if(value != null && value < 0) value = 0;
    if(value != null) valueText = "$value %";

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );

    widget.onFactorSet(value);
  }

  @override
  Widget build(BuildContext context){
    _insertValue();

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    if(widget.isSmallSize){
      return Row(
        children: [
          SizedBox(
            width: theme.perfTextWidth,
            child: Text(
              "Aufschlag",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                color: theme.interactiveHintTextColor,
              ),
            ),
          ),
          Expanded(
            child: ULPTTextField(
              focusNode: focusNode,
              tec: tec,
              alignRight: false,
              hintText: "Aufschlag in %",
              inputFormatter: SFInputFormatter(maxValue: widget.maxValue),
              isOnlyNumbers: true,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ULPTTextField(
              focusNode: focusNode,
              tec: tec,
              alignRight: true,
              hintText: "Aufschlag in %",
              inputFormatter: SFInputFormatter(maxValue: widget.maxValue),
              isOnlyNumbers: true,
          ),
        ),
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            "Aufschlag",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 18,
              color: theme.interactiveHintTextColor,
            ),
          ),
        ),
      ],
    );
  }

  void _insertValue(){
    var valueText = widget.value != null ? "${widget.value} %" : "";
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );
  }
}

class SFInputFormatter extends TextInputFormatter{

  SFInputFormatter({required this.maxValue});

  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) return newValue;
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");
    var value = int.tryParse(corrected);
    if(value != null && value > maxValue) return oldValue;
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(baseOffset: corrected.length, extentOffset: corrected.length),
        composing: TextRange.empty
    );
  }
}
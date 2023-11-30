import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_textfield.dart';

///Text entry to set a performance factor.
class FactorAdjustField extends StatefulWidget {
  const FactorAdjustField({
    Key? key,
    required this.message,
    required this.onFactorSet,
    this.value,
    this.isLastInGroup = false,
  }) : super(key: key);

  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<double?> onFactorSet;
  ///the current value
  final int? value;
  ///text that shows before or after the field
  final String message;
  ///Won't focus the next field when submitted
  final bool isLastInGroup;

  @override
  State<FactorAdjustField> createState() => _FactorAdjustFieldState();
}

class _FactorAdjustFieldState extends State<FactorAdjustField> {

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
    if(tec.value.text.contains("%") == false) return;
    tec.value = tec.value.copyWith(
        selection: TextSelection(baseOffset: tec.value.text.indexOf("%") - 1, extentOffset: tec.value.text.indexOf("%") - 1),
        composing: TextRange.empty
    );
  }

  void onSubmitted(){
    String valueText = "";
    var value = _getNumberFromEntry();

    if(value != null && value < 0) value = 0;
    if(value != null) valueText = "$value %";

    var selIndex = value == null ? 0 : valueText.indexOf("%") - 1;

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: selIndex, extentOffset: selIndex),
        composing: TextRange.empty
    );

    widget.onFactorSet(value == null ? null : double.parse(((value / 100) + 1.0).toStringAsFixed(2)));
  }

  int? _getNumberFromEntry(){
    var s = RegExp(r'\d+').firstMatch(tec.value.text)?.group(0);
    if(s == null) return null;
    return int.tryParse(s);
  }

  @override
  Widget build(BuildContext context){
    _insertValue();

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              flex: constraints.maxWidth > 600 ? 2 : 3,
              child: Text(
                widget.message,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.interactiveHintTextColor,
                ),
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: ULPTTextField(
                focusNode: focusNode,
                tec: tec,
                alignRight: true,
                hintText: "Faktor in %",
                inputFormatter: PFInputFormatter(),
                isOnlyNumbers: true,
                isLastInFocusGroup: widget.isLastInGroup,
              ),
            ),
          ],
        );
      },
    );
  }

  void _insertValue(){
    var valueText = widget.value != null ? "${widget.value} %" : "";
    var selIndex = widget.value == null ? 0 : valueText.indexOf("%") - 1;

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: selIndex, extentOffset: selIndex),
        composing: TextRange.empty
    );
  }
}

class PFInputFormatter extends TextInputFormatter{

  PFInputFormatter();
  final regex = RegExp(r'(^\d+\s?%?$)|(^\d+\s?$)');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) return newValue;
    var corrected = newValue;
    if(regex.hasMatch(corrected.text) == false) corrected = oldValue;
    return corrected;
  }
}
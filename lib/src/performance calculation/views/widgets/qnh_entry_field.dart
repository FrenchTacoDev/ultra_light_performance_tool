import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to set the QNH.
class QNHEntryField extends StatefulWidget {
  const QNHEntryField({
    Key? key,
    this.value,
    required this.onQNHSet,
    this.maxValue = 1100,
    this.minValue = 900,
    this.isSmallSize = false,
  }) : super(key: key);

  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onQNHSet;
  ///maximum value that is set if given value is higher
  final int maxValue;
  ///minimum value that is set if given value is lower
  final int minValue;
  ///the current value
  final int? value;
  ///used for screen size adjustment
  final bool isSmallSize;

  @override
  State<QNHEntryField> createState() => _QNHEntryFieldState();
}

class _QNHEntryFieldState extends State<QNHEntryField> {

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
      widget.onQNHSet(null);
      tec.value = tec.value.copyWith(
          text: "",
          selection: const TextSelection(baseOffset: 0, extentOffset: 0),
          composing: TextRange.empty
      );
      return;
    }

    onSubmitted();
  }

  void onSubmitted() async{
    if(tec.value.text.isEmpty) return;

    String valueText = "";
    var value = int.tryParse(tec.value.text);

    bool isToHigh = value != null && value > widget.maxValue;
    bool isToLow = value != null && value < widget.minValue;
    if(value != null && isToHigh == false && isToLow == false) valueText = "$value HPa";

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );

    if(isToHigh || isToLow){
      await _showQNHErrorDialog(toHigh: isToHigh);
      focusNode.requestFocus();
      return;
    }

    widget.onQNHSet(value);
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
              Localizer.of(context).pcQnhTitle,
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
              hintText: Localizer.of(context).enter,
              alignRight: false,
              inputFormatter: QNHInputFormatter(),
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
              hintText: Localizer.of(context).enter,
              alignRight: true,
              inputFormatter: QNHInputFormatter(),
              isOnlyNumbers: true,
          ),
        ),
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            Localizer.of(context).pcQnhTitle,
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
    var valueText = widget.value != null ? "${widget.value} HPa" : "";
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );
  }

  _showQNHErrorDialog({bool toHigh = true}){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localizer.of(context).pcQnhError, textAlign: TextAlign.center,),
        content: Text(
            toHigh ? Localizer.of(context).pcQnhTooHigh : Localizer.of(context).pcQnhTooLow,
            textAlign: TextAlign.center
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localizer.of(context).ok),
          )
        ],
      ),
    );
  }
}

class QNHInputFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) return newValue;
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(baseOffset: corrected.length, extentOffset: corrected.length),
        composing: TextRange.empty
    );
  }
}
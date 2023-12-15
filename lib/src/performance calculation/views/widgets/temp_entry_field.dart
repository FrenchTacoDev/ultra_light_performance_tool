import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/utils/input_utils.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

///Text entry to set the temperature.
class TemperatureEntryField extends StatefulWidget {
  const TemperatureEntryField({
    Key? key,
    required this.onTempSet,
    this.value,
    this.maxTemp = 60,
    this.minTemp = -20,
    this.isSmallSize = false,
  }) : super(key: key);

  ///maximum value that is set if given value is higher
  final int maxTemp;
  ///minimum value that is set if given value is lower
  final int minTemp;
  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<int?> onTempSet;
  ///the current value
  final int? value;
  ///used for screen size adjustment
  final bool isSmallSize;

  @override
  State<TemperatureEntryField> createState() => _TemperatureEntryFieldState();
}

class _TemperatureEntryFieldState extends State<TemperatureEntryField> {

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
      widget.onTempSet(null);
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
    var value = InputUtils.parseTemperature(tec.value.text);
    
    String valueText = "";
    
    if(value != null && (value > widget.maxTemp || value < widget.minTemp)){
      await _showTempErrorDialog(toHigh: value > widget.maxTemp);
      value = null;
      focusNode.requestFocus();
    }else{
      valueText = "${value ?? 15} °C";
    }
    
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );

    widget.onTempSet(value);
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
              Localizer.of(context).pcTempTitle,
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
              hintText: Localizer.of(context).enter,
              inputFormatter: TempInputFormatter(),
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
              hintText: Localizer.of(context).enter,
              inputFormatter: TempInputFormatter(),
              isOnlyNumbers: true,
          ),
        ),
        SizedBox(
          width: theme.perfTextWidth,
          child: Text(
            Localizer.of(context).pcTempTitle,
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
    var valueText = widget.value != null ? "${widget.value} °C" : "";
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );
  }
  
  _showTempErrorDialog({bool toHigh = true}){
    showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(Localizer.of(context).pcTempInvalidTitle, textAlign: TextAlign.center,),
          content: Text(
              toHigh ? Localizer.of(context).pcTempTooHigh : Localizer.of(context).pcTempTooLow,
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

class TempInputFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) return newValue;
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9-°cC]'), "");
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(baseOffset: corrected.length, extentOffset: corrected.length),
        composing: TextRange.empty
    );
  }
}
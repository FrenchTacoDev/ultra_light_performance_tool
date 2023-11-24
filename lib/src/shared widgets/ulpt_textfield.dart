import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

///Text Field implementation that uses the [ULPTTheme].
///Adjusts the keyboard to String or Number entry
///If [isLastInFocusGroup] is selected true, will unfocus the field on submit and now select the next focus.
///Also a Done button is shown on mobile.
class ULPTTextField extends StatelessWidget {
  const ULPTTextField({
    super.key,
    required this.focusNode,
    required this.tec,
    required this.hintText,
    this.inputFormatter,
    this.enabled,
    this.alignRight = false,
    this.isOnlyNumbers = false,
    this.isLastInFocusGroup = false,
  });

  final FocusNode focusNode;
  final TextEditingController tec;
  final String hintText;
  final TextInputFormatter? inputFormatter;
  final bool? enabled;
  final bool alignRight;
  final bool isOnlyNumbers;
  final bool isLastInFocusGroup;

  @override
  Widget build(BuildContext context) {

    var disabled = enabled == false;
    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
          color: disabled ? theme.interactiveDisabledColor : theme.interactiveBGColor,
          borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        enabled: enabled,
        cursorColor: theme.interactiveFocusedColor,
        focusNode: focusNode,
        textAlign: alignRight ? TextAlign.end : TextAlign.start,
        style: TextStyle(color: theme.interactiveFocusedColor),
        maxLines: 1,
        controller: tec,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: isLastInFocusGroup ? TextInputAction.done : TextInputAction.next,
        keyboardType: _getMatchingKeyboard(isNumbersOnly: isOnlyNumbers),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13.5),
          hintStyle: TextStyle(color: disabled ? theme.interactiveHintDisabledColor : theme.interactiveHintTextColor),
          isDense: true,
          border: null,
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
          disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
          errorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
          focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
        inputFormatters: inputFormatter == null ? [] : [
          inputFormatter!,
        ],
      ),
    );
  }

  TextInputType? _getMatchingKeyboard({required bool isNumbersOnly}){
    if(Platform.isIOS && isNumbersOnly) return TextInputType.datetime;
    if(Platform.isAndroid && isNumbersOnly) return TextInputType.number;
    return TextInputType.text;
  }
}

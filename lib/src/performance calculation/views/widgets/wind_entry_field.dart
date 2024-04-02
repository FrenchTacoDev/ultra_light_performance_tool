import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_textfield.dart';
import 'package:ultra_light_performance_tool/src/utils/input_utils.dart';
import 'package:ultra_light_performance_tool/src/localization/localizer.dart';

typedef Wind = ({int direction, int speed});

///Text entry to set the wind.
class WindEntryField extends StatefulWidget {
  const WindEntryField({
    Key? key,
    required this.onWindSet,
    this.runwayCourse,
    this.value,
    this.isSmallSize = false,
    this.hwc,
    this.xwc,
  }) : super(key: key);

  ///callback function that is called when field is submitted or looses focus
  final ValueSetter<Wind?> onWindSet;
  ///runway course to calculate the head or crosswind component
  final int? runwayCourse;
  ///the current value
  final Wind? value;
  ///used for screen size adjustment
  final bool isSmallSize;
  ///the headwind component shown if delivered
  final int? hwc;
  ///the crosswind component shown if delivered
  final int? xwc;

  @override
  State<WindEntryField> createState() => _WindEntryFieldState();
}

class _WindEntryFieldState extends State<WindEntryField> {

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
      widget.onWindSet(null);
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

    try{
      var value = InputUtils.parseWind(input: tec.value.text, rwyCourse: widget.runwayCourse!);
      valueText = "${value.direction < 100 ? "0${value.direction}" : value.direction} / ${value.speed} KT";
      widget.onWindSet(value);
    }on WindFormatError{
      _showWindErrorDialog(message: Localizer.of(context).pcWindFormatError);
    }on WindDirectionError{
      _showWindErrorDialog(message: Localizer.of(context).pcWindDirError);
    }on WindSpeedError{
      _showWindErrorDialog(message: Localizer.of(context).pcWindSpdError);
    }catch (e){
      rethrow;
    }

    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );
  }

  @override
  Widget build(BuildContext context){

    _insertValue();

    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    var hwxwText = "";
    if(widget.hwc != null && widget.xwc != null){
      var xwText = widget.xwc! < 0 ? Localizer.of(context).pcXwlShort : widget.xwc! == 0 ? Localizer.of(context).pcXwShort
          : Localizer.of(context).pcXwrShort;
      hwxwText = widget.hwc! >= 0 ? "${widget.hwc} ${Localizer.of(context).pcHwShort} / ${widget.xwc!.abs()} $xwText KT" :
      "${widget.hwc!.abs()} ${Localizer.of(context).pcTWShort} / ${widget.xwc!.abs()} $xwText KT";
    }

    if(widget.isSmallSize){
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: theme.perfTextWidth,
                child: Text(
                  Localizer.of(context).pcWindTitle,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.interactiveHintTextColor,
                  ),
                ),
              ),
              Expanded(
                child: ULPTTextField(
                  enabled: widget.runwayCourse != null,
                  focusNode: focusNode,
                  hintText: Localizer.of(context).enter,
                  alignRight: false,
                  tec: tec,
                  inputFormatter: WindInputFormatter(),
                  isOnlyNumbers: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              SizedBox(width: theme.perfTextWidth + 8,),
              if(hwxwText.isNotEmpty) Expanded(
                  child: Text(
                    hwxwText,
                    style: TextStyle(fontSize: 12, color: theme.interactiveHintTextColor,),
                    textAlign: TextAlign.left,
                  )
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ULPTTextField(
                enabled: widget.runwayCourse != null,
                focusNode: focusNode,
                hintText: Localizer.of(context).enter,
                alignRight: true,
                tec: tec,
                inputFormatter: WindInputFormatter(),
                isOnlyNumbers: true,
              ),
            ),
            SizedBox(
              width: theme.perfTextWidth,
              child: Text(
                Localizer.of(context).pcWindTitle,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.interactiveHintTextColor,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Text(
                  hwxwText,
                  style: TextStyle(
                      fontSize: 12,
                      color: theme.interactiveHintTextColor),
                      textAlign: TextAlign.right,
                )
            ),
            SizedBox(width: theme.perfTextWidth + 8,),
          ],
        ),
      ],
    );
  }

  void _insertValue(){
    var valueText = "";
    if(widget.value != null) {
      valueText = "${widget.value!.direction < 100 ? "0${widget.value!.direction}"
          : widget.value!.direction} / ${widget.value!.speed} KT";
    }
    tec.value = tec.value.copyWith(
        text: valueText,
        selection: TextSelection(baseOffset: valueText.length, extentOffset: valueText.length),
        composing: TextRange.empty
    );
  }

  void _showWindErrorDialog({required String message}) async{
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localizer.of(context).pcWindErrorTitle, textAlign: TextAlign.center,),
        content: Text(message, textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localizer.of(context).ok),
          )
        ],
      ),
    );

    focusNode.requestFocus();
  }
}

class WindInputFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isEmpty) return newValue;
    if(newValue.text.length < oldValue.text.length) return newValue;
    var corrected = newValue.text.replaceAll(RegExp(r'[^0-9/-]'), "");
    return newValue.copyWith(
        text: corrected,
        selection: TextSelection(baseOffset: corrected.length, extentOffset: corrected.length),
        composing: TextRange.empty
    );
  }
}


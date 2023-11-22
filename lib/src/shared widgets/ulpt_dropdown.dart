import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/res/colors.dart';
import 'package:ultra_light_performance_tool/src/res/themes.dart';

///Dropdown using the [ULPTTheme]
class ULPTDropdown<T> extends StatefulWidget {
  const ULPTDropdown({
    super.key,
    this.value,
    required this.items,
    this.parseItem,
    this.fromString,
    required this.hint,
    required this.onChanged,
    this.alignRight = false,
  });

  final T? value;
  final List<T> items;
  ///internally dropdown only uses Strings. So String parsing is required.
  final String Function(T item)? parseItem;
  ///internally dropdown only uses Strings. So String parsing is required.
  final T? Function(String s)? fromString;
  final bool alignRight;

  final ValueSetter<T?>? onChanged;
  ///Is shown if no item is selected
  final String hint;

  @override
  State<ULPTDropdown<T>> createState() => _ULPTDropdownState<T>();
}

class _ULPTDropdownState<T> extends State<ULPTDropdown<T>> {

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() => setState((){}));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool disabled = widget.onChanged == null || widget.items.isEmpty;
    var theme = Theme.of(context).extensions[ULPTTheme] as ULPTTheme;

    final TextStyle hintStyle = TextStyle(color: theme.interactiveHintTextColor);
    final TextStyle hintDisabled = TextStyle(color: theme.interactiveHintDisabledColor);
    final TextStyle selected = TextStyle(color: theme.interactiveFocusedColor);

    var selectedItemWidgets = <Widget>[];

    for(var item in widget.items){
      selectedItemWidgets.add(
          Text(
            (widget.parseItem == null ? item.toString() : widget.parseItem!(item)),
            style: selected,
          )
      );
    }

    Color bgColor = theme.interactiveBGColor;
    if(disabled) bgColor = theme.interactiveDisabledColor;
    if(focusNode.hasFocus) bgColor = theme.interactiveFocusBGColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),

      //Uses String value as a workaround bc object produce false errors in dropdown implementation
      child: DropdownButton<String>(
        focusNode: focusNode,
        alignment: widget.alignRight ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
        borderRadius: BorderRadius.circular(10),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: Platform.isIOS ? 11 : 8),
        underline: Container(),
        dropdownColor: CustomColors.bgGrey,
        value: widget.value == null ? null : (widget.parseItem == null ? widget.value.toString() : widget.parseItem!(widget.value!)),
        items: createItems(theme),
        hint: Text(widget.hint, style: disabled ? hintDisabled : hintStyle),
        selectedItemBuilder: (context) => selectedItemWidgets,
        onChanged: (s){
          if(widget.onChanged == null) return;
          if(s == null) return widget.onChanged!(null);
          if(widget.fromString != null) return widget.onChanged!(widget.fromString!(s));
          widget.onChanged!(widget.items.where((element) => element.toString() == s).firstOrNull);
        },
        isDense: true,
        isExpanded: true,
      ),
    );
  }

  List<DropdownMenuItem<String>> createItems(ULPTTheme theme){
    var ddItems = <DropdownMenuItem<String>>[];

    final TextStyle textStyle = TextStyle(color: theme.interactiveHintTextColor);

    for(T item in widget.items){
      ddItems.add(
        DropdownMenuItem<String>(
            value: widget.parseItem == null ? item.toString() : widget.parseItem!(item),
            child: Text(
              widget.parseItem == null ? item.toString() : widget.parseItem!(item),
              style: textStyle,
            ),
        )
      );
    }

    return ddItems;
  }
}




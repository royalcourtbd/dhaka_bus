import 'package:dhaka_bus/core/external_libs/user_input_field/src/user_input_field_widget.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:flutter/material.dart';

class BusSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final EdgeInsets padding;
  final Color fillColor;

  const BusSearchWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    this.fillColor = const Color(0xffEEEEEE),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: UserInputField(
        textEditingController: controller,
        hintText: hintText,
        prefixIconPath: SvgPath.icSearch,
        fillColor: fillColor,
        onChanged: onChanged,
        onTapSuffixIcon:
            onClear ??
            () {
              controller.clear();
              onChanged('');
            },
        suffixIconPath: controller.text.isNotEmpty ? SvgPath.icCross : null,
      ),
    );
  }
}

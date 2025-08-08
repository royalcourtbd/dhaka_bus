import 'package:flutter/material.dart';

class ActionListTileTheme {
  final double iconSize;
  final double iconTextGap;
  final double containerHeight;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final Color? iconColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool enableRipple;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const ActionListTileTheme({
    this.iconSize = 21.0,
    this.iconTextGap = 20.0,
    this.containerHeight = 55.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.textStyle = const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    ),
    this.iconColor,
    this.backgroundColor,
    this.borderRadius,
    this.enableRipple = true,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  ActionListTileTheme copyWith({
    double? iconSize,
    double? iconTextGap,
    double? containerHeight,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? iconColor,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    bool? enableRipple,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return ActionListTileTheme(
      iconSize: iconSize ?? this.iconSize,
      iconTextGap: iconTextGap ?? this.iconTextGap,
      containerHeight: containerHeight ?? this.containerHeight,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      enableRipple: enableRipple ?? this.enableRipple,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
    );
  }
}

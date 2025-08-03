import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

InputDecoration userInputDecoration({
  required BuildContext context,
  required String hintText,
  required BorderRadius borderRadius,
  TextStyle? hintStyle,
  bool enabled = true,
  String? suffixIconPath,
  Color? suffixIconColor,
  String? prefixIconPath,
  EdgeInsetsGeometry? contentPadding,
  VoidCallback? onTapSuffixIcon,
  Color? prefixIconColor,
  bool showPrefixIcon = true,
  double? borderWidth,
  Color? borderColor,
  Color? focusedBorderColor,
  Color? enabledBorderColor,
  Color? disabledBorderColor,
  Color? fillColor,
  String? errorText,
}) {
  final ThemeData theme = Theme.of(context);
  final TextTheme textTheme = theme.textTheme;

  return InputDecoration(
    counterText: '',
    errorStyle: TextStyle(height: 0, fontSize: 0),
    counterStyle: TextStyle(height: 0, fontSize: 0),

    enabled: enabled,
    border: outlineInputBorder(
      context: context,
      borderRadius: borderRadius,
      borderWidth: borderWidth ?? 0.8,

      borderColor:
          errorText != null ? Colors.red : (borderColor ?? Colors.transparent),
    ),
    focusedBorder: outlineInputBorder(
      context: context,
      borderRadius: borderRadius,
      borderWidth: borderWidth ?? 0.8,
      borderColor:
          errorText != null
              ? Colors.red
              : (focusedBorderColor ?? borderColor ?? Colors.transparent),
    ),

    enabledBorder: outlineInputBorder(
      context: context,
      borderRadius: borderRadius,
      borderWidth: borderWidth ?? 0.8,
      borderColor:
          errorText != null
              ? Colors.red
              : (enabledBorderColor ?? borderColor ?? Colors.transparent),
    ),
    disabledBorder: outlineInputBorder(
      context: context,
      borderRadius: borderRadius,
      borderWidth: borderWidth ?? 0.8,
      borderColor:
          errorText != null
              ? Colors.red
              : (disabledBorderColor ?? borderColor ?? Colors.transparent),
    ),
    contentPadding: contentPadding ?? const EdgeInsets.all(5),
    hintText: hintText,
    filled: true,
    fillColor: fillColor ?? theme.inputDecorationTheme.fillColor,
    hintStyle:
        hintStyle ??
        textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black38,
        ),
    suffixIcon:
        suffixIconPath != null
            ? GestureDetector(
              onTap: () {
                if (onTapSuffixIcon != null) {
                  onTapSuffixIcon();
                }
              },
              child: SvgPicture.asset(
                suffixIconPath,
                fit: BoxFit.scaleDown,
                height: 22,
                width: 22,
                colorFilter: ColorFilter.mode(
                  suffixIconColor ?? theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            )
            : null,
    prefixIcon:
        showPrefixIcon
            ? (prefixIconPath != null && prefixIconPath.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset(
                    prefixIconPath,
                    fit: BoxFit.scaleDown,
                    height: 22,
                    width: 22,
                    colorFilter: ColorFilter.mode(
                      prefixIconColor ?? theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.search,
                    size: 22,
                    color: prefixIconColor ?? theme.colorScheme.primary,
                  ),
                ))
            : null,
  );
}

OutlineInputBorder outlineInputBorder({
  required BuildContext context,
  required BorderRadius borderRadius,
  double? borderWidth,
  Color? borderColor,
}) {
  return OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: BorderSide(
      width: borderWidth ?? 0.8,
      color: borderColor ?? Colors.transparent,
    ),
  );
}

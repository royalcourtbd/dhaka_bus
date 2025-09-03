import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/shared/components/submit_button.dart';
import 'package:flutter/material.dart';

class TwoWayActionButton extends StatelessWidget {
  const TwoWayActionButton({
    super.key,
    required this.theme,
    this.svgPictureForOkButton,
    this.svgPictureForCancelButton,
    required this.submitButtonTitle,
    required this.cancelButtonTitle,
    this.onSubmitButtonTap,
    this.onCancelButtonTap,
    this.submitButtonBgColor,
    this.submitButtonTextColor,
    this.cancelButtonBgColor,
    this.cancelButtonTextColor,
    this.isLoading = false,
    this.submitButtonFontSize,
    this.submitButtonFontWeight,
    this.submitButtonFontFamily,
    this.submitButtonCustomTextStyle,
    this.cancelButtonFontSize,
    this.cancelButtonFontWeight,
    this.cancelButtonFontFamily,
    this.cancelButtonLetterSpacing,
    this.cancelButtonTextDecoration,
    this.cancelButtonCustomTextStyle,
    this.commonFontSize,
    this.commonFontWeight,
    this.commonFontFamily,
  });

  final Widget? svgPictureForOkButton;
  final Widget? svgPictureForCancelButton;
  final String submitButtonTitle;
  final String cancelButtonTitle;
  final VoidCallback? onSubmitButtonTap;
  final VoidCallback? onCancelButtonTap;
  final Color? submitButtonBgColor;
  final Color? submitButtonTextColor;
  final Color? cancelButtonBgColor;
  final Color? cancelButtonTextColor;
  final bool isLoading;
  final ThemeData theme;

  final double? submitButtonFontSize;
  final FontWeight? submitButtonFontWeight;
  final String? submitButtonFontFamily;
  final TextStyle? submitButtonCustomTextStyle;

  final double? cancelButtonFontSize;
  final FontWeight? cancelButtonFontWeight;
  final String? cancelButtonFontFamily;
  final double? cancelButtonLetterSpacing;
  final TextDecoration? cancelButtonTextDecoration;
  final TextStyle? cancelButtonCustomTextStyle;

  final double? commonFontSize;
  final FontWeight? commonFontWeight;
  final String? commonFontFamily;

  @override
  Widget build(BuildContext context) {
    final submitBgColor = submitButtonBgColor ?? theme.colorScheme.primary;
    final submitTextColor =
        submitButtonTextColor ?? theme.colorScheme.onPrimary;
    final cancelBgColor = cancelButtonBgColor ?? context.color.primaryColor25;
    final cancelTextColor = cancelButtonTextColor ?? context.color.titleColor;
    final submitIcon = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(submitTextColor),
            ),
          )
        : svgPictureForOkButton;

    return Row(
      children: [
        Flexible(
          child: SubmitButton(
            theme: theme,
            svgPicture: svgPictureForCancelButton,
            title: cancelButtonTitle,
            onTap: onCancelButtonTap,
            buttonColor: cancelBgColor,
            textColor: cancelTextColor,

            fontSize: cancelButtonFontSize ?? commonFontSize,
            fontWeight: cancelButtonFontWeight ?? commonFontWeight,
            fontFamily: cancelButtonFontFamily ?? commonFontFamily,
            customTextStyle: cancelButtonCustomTextStyle,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: SubmitButton(
            theme: theme,
            svgPicture: submitIcon,
            title: submitButtonTitle,
            onTap: isLoading ? null : onSubmitButtonTap,
            buttonColor: submitBgColor,
            textColor: submitTextColor,
            fontSize: submitButtonFontSize ?? commonFontSize,
            fontWeight: submitButtonFontWeight ?? commonFontWeight,
            fontFamily: submitButtonFontFamily ?? commonFontFamily,
            customTextStyle: submitButtonCustomTextStyle,
          ),
        ),
      ],
    );
  }
}

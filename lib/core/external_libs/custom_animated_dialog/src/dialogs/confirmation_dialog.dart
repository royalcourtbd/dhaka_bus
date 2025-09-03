import 'package:dhaka_bus/shared/components/two_way_action_button.dart';
import 'package:flutter/material.dart';
import '../core/animated_dialog_base.dart';
import '../enums/dialog_transition_type.dart';
import '../enums/dialog_icon_type.dart';
import '../utils/dialog_icon_builder.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.icon,
    this.submitButtonBgColor,
    this.submitButtonTextColor,
    this.cancelButtonBgColor,
    this.cancelButtonTextColor,
    this.svgPictureForOkButton,
    this.svgPictureForCancelButton,
    this.isLoading = false,
    this.showIcon = true,
    this.customIcon,
    this.customSvgIconPath,
    this.iconSize = 48,
    this.submitButtonFontSize,
    this.submitButtonFontWeight,
    this.submitButtonCustomTextStyle,
    this.cancelButtonFontSize,
    this.cancelButtonFontWeight,
    this.cancelButtonCustomTextStyle,
    this.overrideIconColor = true,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final Widget? icon;
  final Color? submitButtonBgColor;
  final Color? submitButtonTextColor;
  final Color? cancelButtonBgColor;
  final Color? cancelButtonTextColor;
  final Widget? svgPictureForOkButton;
  final Widget? svgPictureForCancelButton;
  final bool isLoading;
  final bool showIcon;
  final IconData? customIcon;
  final String? customSvgIconPath;
  final double iconSize;

  final double? submitButtonFontSize;
  final FontWeight? submitButtonFontWeight;
  final TextStyle? submitButtonCustomTextStyle;

  final double? cancelButtonFontSize;
  final FontWeight? cancelButtonFontWeight;
  final TextStyle? cancelButtonCustomTextStyle;
  final bool overrideIconColor;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    Widget? icon,
    DialogTransitionType animationType = DialogTransitionType.scale,
    Curve curve = Curves.fastOutSlowIn,
    bool barrierDismissible = true,
    Color? submitButtonBgColor,
    Color? submitButtonTextColor,
    Color? cancelButtonBgColor,
    Color? cancelButtonTextColor,
    Widget? svgPictureForOkButton,
    Widget? svgPictureForCancelButton,
    bool isLoading = false,
    bool showIcon = true,
    IconData? customIcon,
    String? customSvgIconPath,
    double iconSize = 48,

    double? submitButtonFontSize,
    FontWeight? submitButtonFontWeight,
    TextStyle? submitButtonCustomTextStyle,

    double? cancelButtonFontSize,
    FontWeight? cancelButtonFontWeight,
    TextStyle? cancelButtonCustomTextStyle,
    bool overrideIconColor = true,
  }) async {
    return await showAnimatedDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      animationType: animationType,
      curve: curve,
      builder: (_) => ConfirmationDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        icon: icon,
        submitButtonBgColor: submitButtonBgColor,
        submitButtonTextColor: submitButtonTextColor,
        cancelButtonBgColor: cancelButtonBgColor,
        cancelButtonTextColor: cancelButtonTextColor,
        svgPictureForOkButton: svgPictureForOkButton,
        svgPictureForCancelButton: svgPictureForCancelButton,
        isLoading: isLoading,
        showIcon: showIcon,
        customIcon: customIcon,
        customSvgIconPath: customSvgIconPath,
        iconSize: iconSize,
        submitButtonFontSize: submitButtonFontSize,
        submitButtonFontWeight: submitButtonFontWeight,
        submitButtonCustomTextStyle: submitButtonCustomTextStyle,
        cancelButtonFontSize: cancelButtonFontSize,
        cancelButtonFontWeight: cancelButtonFontWeight,
        cancelButtonCustomTextStyle: cancelButtonCustomTextStyle,
        overrideIconColor: overrideIconColor,
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    if (!showIcon) return const SizedBox.shrink();

    if (icon != null) {
      return icon!;
    } else if (customSvgIconPath != null) {
      return DialogIconBuilder.build(
        iconType: DialogIconType.svg,
        iconData: customSvgIconPath!,
        size: iconSize,
        color: overrideIconColor
            ? (isDestructive ? colorScheme.error : colorScheme.primary)
            : null,
      );
    } else if (customIcon != null) {
      return DialogIconBuilder.build(
        iconType: DialogIconType.materialIcon,
        iconData: customIcon!,
        size: iconSize,
        color: isDestructive ? colorScheme.error : colorScheme.primary,
      );
    } else {
      final defaultIcon = isDestructive ? Icons.warning : Icons.help_outline;
      return DialogIconBuilder.build(
        iconType: DialogIconType.materialIcon,
        iconData: defaultIcon,
        size: iconSize,
        color: isDestructive ? colorScheme.error : colorScheme.primary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: DialogTheme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(colorScheme),
            if (showIcon) const SizedBox(height: 30),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 46),
            TwoWayActionButton(
              theme: theme,
              submitButtonTitle: confirmText,
              cancelButtonTitle: cancelText,
              onSubmitButtonTap: () {
                onConfirm();
                Navigator.pop(context);
              },
              onCancelButtonTap: () {
                onCancel?.call();
                Navigator.pop(context);
              },
              submitButtonBgColor: submitButtonBgColor,
              submitButtonTextColor: submitButtonTextColor,
              submitButtonFontSize: submitButtonFontSize,
              submitButtonFontWeight: submitButtonFontWeight,
              submitButtonCustomTextStyle: submitButtonCustomTextStyle,
              cancelButtonFontSize: cancelButtonFontSize,
              cancelButtonFontWeight: cancelButtonFontWeight,
              cancelButtonCustomTextStyle: cancelButtonCustomTextStyle,
              cancelButtonBgColor: cancelButtonBgColor,
              cancelButtonTextColor: cancelButtonTextColor,
              svgPictureForOkButton: svgPictureForOkButton,
              svgPictureForCancelButton: svgPictureForCancelButton,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

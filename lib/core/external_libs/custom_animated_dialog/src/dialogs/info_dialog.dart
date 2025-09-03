import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/shared/components/submit_button.dart';
import 'package:flutter/material.dart';
import '../core/animated_dialog_base.dart';
import '../enums/dialog_transition_type.dart';
import '../enums/info_dialog_type.dart';
import '../enums/dialog_icon_type.dart';
import '../utils/dialog_icon_builder.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = InfoDialogType.info,
    this.buttonText = 'OK',
    this.onPressed,
    this.buttonColor,
    this.textColor,
    this.svgPicture,
    this.buttonHeight,
    this.fontFamily,
    this.showIcon = true,
    this.customIcon,
    this.buttonCustomTextStyle,
    this.buttonFontSize,
    this.buttonFontWeight,
    this.customIconPath,
    this.iconSize = 48,
  });

  final String title;
  final String message;
  final InfoDialogType type;
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final Widget? svgPicture;
  final double? buttonHeight;
  final String? fontFamily;
  final bool showIcon;
  final IconData? customIcon;
  final String? customIconPath;
  final double iconSize;

  final double? buttonFontSize;
  final FontWeight? buttonFontWeight;
  final TextStyle? buttonCustomTextStyle;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    InfoDialogType type = InfoDialogType.info,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    DialogTransitionType animationType = DialogTransitionType.scale,
    bool barrierDismissible = true,
    Color? buttonColor,
    Color? textColor,
    Widget? svgPicture,
    double? buttonHeight,
    String? fontFamily,
    bool showIcon = true,
    IconData? customIcon,
    String? customIconPath,
    double iconSize = 48,
    double? buttonFontSize,
    FontWeight? buttonFontWeight,
    TextStyle? buttonCustomTextStyle,
  }) async {
    return showAnimatedDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      animationType: animationType,
      builder: (_) => InfoDialog(
        title: title,
        message: message,
        type: type,
        buttonText: buttonText,
        onPressed: onPressed,
        buttonColor: buttonColor,
        textColor: textColor,
        svgPicture: svgPicture,
        buttonHeight: buttonHeight,
        fontFamily: fontFamily,
        showIcon: showIcon,
        customIcon: customIcon,
        customIconPath: customIconPath,
        iconSize: iconSize,
        buttonFontSize: buttonFontSize,
        buttonFontWeight: buttonFontWeight,
        buttonCustomTextStyle: buttonCustomTextStyle,
      ),
    );
  }

  Color _getTypeColor(ColorScheme colorScheme) {
    switch (type) {
      case InfoDialogType.success:
        return Colors.green;
      case InfoDialogType.warning:
        return Colors.orange;
      case InfoDialogType.error:
        return colorScheme.error;
      case InfoDialogType.info:
        return colorScheme.primary;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case InfoDialogType.success:
        return Icons.check_circle;
      case InfoDialogType.warning:
        return Icons.warning;
      case InfoDialogType.error:
        return Icons.error;
      case InfoDialogType.info:
        return Icons.info;
    }
  }

  Widget _buildIcon(Color typeColor) {
    if (!showIcon) return const SizedBox.shrink();

    if (customIconPath != null) {
      return DialogIconBuilder.build(
        iconType: DialogIconType.svg,
        iconData: customIconPath!,
        size: iconSize,
        color: typeColor,
      );
    } else if (customIcon != null) {
      return DialogIconBuilder.build(
        iconType: DialogIconType.materialIcon,
        iconData: customIcon!,
        size: iconSize,
        color: typeColor,
      );
    } else {
      return DialogIconBuilder.build(
        iconType: DialogIconType.materialIcon,
        iconData: _getTypeIcon(),
        size: iconSize,
        color: typeColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeColor = _getTypeColor(colorScheme);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(typeColor),
            if (showIcon) const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SubmitButton(
              theme: theme,
              title: buttonText,
              buttonColor: buttonColor ?? typeColor,
              textColor: textColor ?? Colors.white,
              svgPicture: svgPicture,
              buttonHeight: buttonHeight,
              fontFamily: fontFamily,
              fontSize: buttonFontSize,
              fontWeight: buttonFontWeight,
              customTextStyle: buttonCustomTextStyle,
              onTap: () {
                context.navigatorPop();
                onPressed?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

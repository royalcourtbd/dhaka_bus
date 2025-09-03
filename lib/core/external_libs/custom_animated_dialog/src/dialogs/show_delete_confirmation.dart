import 'package:dhaka_bus/core/external_libs/custom_animated_dialog/custom_animated_dialog.dart';

import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmation({
  required BuildContext context,
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
  String confirmText = 'Delete',
  bool isDestructive = true,
  String customSvgIconPath = SvgPath.icDeleteIllustration,
  double iconSize = 170,
  DialogTransitionType animationType = DialogTransitionType.scale,
  bool overrideIconColor = true,
}) {
  ConfirmationDialog.show(
    context: context,
    cancelButtonBgColor: Colors.transparent,
    submitButtonBgColor: Colors.transparent,
    submitButtonTextColor: Theme.of(context).colorScheme.error,
    cancelButtonFontWeight: FontWeight.bold,
    submitButtonFontWeight: FontWeight.bold,
    title: title,
    message: message,
    confirmText: confirmText,
    isDestructive: isDestructive,
    customSvgIconPath: customSvgIconPath,
    iconSize: iconSize,
    animationType: animationType,
    onConfirm: onConfirm,
    overrideIconColor: overrideIconColor,
  );
}

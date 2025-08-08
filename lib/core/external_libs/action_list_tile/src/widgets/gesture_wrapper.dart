import 'package:dhaka_bus/shared/components/ontap_widget.dart';
import 'package:flutter/material.dart';

class GestureWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableRipple;
  final BorderRadius? borderRadius;
  final String? keyName;
  final bool enabled;

  const GestureWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.enableRipple = true,
    this.borderRadius,
    this.keyName,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null || !enabled) {
      return child;
    }

    final key = keyName != null ? Key(keyName!) : null;

    return Material(
      color: Colors.transparent,
      child: OnTapWidget(
        key: key,
        onTap: onTap!,
        enableRipple: enableRipple,
        child: child,
      ),
    );
  }
}

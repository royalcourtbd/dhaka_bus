import 'package:flutter/material.dart';

class OnTapWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableRipple;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? overlayColor;
  final double? borderRadius;

  const OnTapWidget({
    super.key,
    required this.child,
    this.onTap,
    this.enableRipple = true,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
    this.overlayColor,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      overlayColor: overlayColor != null
          ? WidgetStatePropertyAll(overlayColor!)
          : null,
      splashColor: !enableRipple
          ? Colors.transparent
          : splashColor ??
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),

      highlightColor: !enableRipple
          ? Colors.transparent
          : highlightColor ??
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),

      child: child,
    );
  }
}

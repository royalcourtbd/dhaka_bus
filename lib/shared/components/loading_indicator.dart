import 'package:flutter/material.dart';
import 'package:dhaka_bus/core/external_libs/loading_animation/ink_drop_loading_animation.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.ringColor, this.color});

  final Color? color;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: InkDropLoading(
        size: 30,
        ringColor: ringColor ?? theme.primaryColor.withValues(alpha: .3),
        color: color ?? theme.primaryColor,
      ),
    );
  }
}

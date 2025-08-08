import 'package:flutter/material.dart';

class AppSwitchTheme {
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final double scale;
  final double? trackOutlineWidth;
  final Color? trackOutlineColor;
  final MaterialTapTargetSize? materialTapTargetSize;

  const AppSwitchTheme({
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.scale = 0.7,
    this.trackOutlineWidth,
    this.trackOutlineColor,
    this.materialTapTargetSize,
  });

  static const AppSwitchTheme compact = AppSwitchTheme(scale: 0.6);

  static const AppSwitchTheme standard = AppSwitchTheme(scale: 0.8);

  static const AppSwitchTheme large = AppSwitchTheme(scale: 1.0);

  static AppSwitchTheme success = AppSwitchTheme(
    activeTrackColor: Colors.green.withValues(alpha: 0.5),
    activeThumbColor: Colors.green,
  );

  static AppSwitchTheme danger = AppSwitchTheme(
    activeTrackColor: Colors.red.withValues(alpha: 0.5),
    activeThumbColor: Colors.red,
  );
}

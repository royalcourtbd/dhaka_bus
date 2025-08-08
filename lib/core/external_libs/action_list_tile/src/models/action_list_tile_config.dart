import 'package:flutter/material.dart';
import '../enums/icon_type.dart';

class ActionListTileConfig {
  final String title;
  final String? subtitle;
  final dynamic iconData;
  final IconType iconType;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? radioValue;
  final bool? radioGroupValue;
  final ValueChanged<bool?>? onRadioChanged;
  final bool? checkboxValue;
  final ValueChanged<bool?>? onCheckboxChanged;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool showSwitch;
  final bool enabled;
  final Widget? leading;

  const ActionListTileConfig({
    required this.title,
    this.subtitle,
    this.iconData,
    this.iconType = IconType.materialIcon,
    this.trailing,
    this.onTap,
    this.radioValue,
    this.radioGroupValue,
    this.onRadioChanged,
    this.checkboxValue,
    this.onCheckboxChanged,
    this.switchValue,
    this.onSwitchChanged,
    this.showSwitch = false,
    this.enabled = true,
    this.leading,
  });

  ActionListTileConfig copyWith({
    String? title,
    String? subtitle,
    dynamic iconData,
    IconType? iconType,
    Widget? trailing,
    VoidCallback? onTap,
    bool? radioValue,
    bool? radioGroupValue,
    ValueChanged<bool?>? onRadioChanged,
    bool? checkboxValue,
    ValueChanged<bool?>? onCheckboxChanged,
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
    bool? showSwitch,
    bool? enabled,
    Widget? leading,
  }) {
    return ActionListTileConfig(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconData: iconData ?? this.iconData,
      iconType: iconType ?? this.iconType,
      trailing: trailing ?? this.trailing,
      onTap: onTap ?? this.onTap,
      radioValue: radioValue ?? this.radioValue,
      radioGroupValue: radioGroupValue ?? this.radioGroupValue,
      onRadioChanged: onRadioChanged ?? this.onRadioChanged,
      checkboxValue: checkboxValue ?? this.checkboxValue,
      onCheckboxChanged: onCheckboxChanged ?? this.onCheckboxChanged,
      switchValue: switchValue ?? this.switchValue,
      onSwitchChanged: onSwitchChanged ?? this.onSwitchChanged,
      showSwitch: showSwitch ?? this.showSwitch,
      enabled: enabled ?? this.enabled,
      leading: leading ?? this.leading,
    );
  }
}

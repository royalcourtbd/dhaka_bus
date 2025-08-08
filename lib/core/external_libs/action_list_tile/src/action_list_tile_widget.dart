import 'package:dhaka_bus/core/external_libs/app_switch/app_switch.dart';
import 'package:flutter/material.dart';

import 'enums/icon_type.dart';
import 'models/action_list_tile_config.dart';
import 'models/action_list_tile_theme.dart';
import 'widgets/gesture_wrapper.dart';
import 'widgets/icon_builder.dart';

class ActionListTile extends StatelessWidget {
  final ActionListTileConfig config;
  final ActionListTileTheme? theme;

  const ActionListTile({super.key, required this.config, this.theme});

  factory ActionListTile.svg({
    Key? key,
    required String title,
    required String iconPath,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    Widget? trailing,
    bool enabled = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconData: iconPath,
        iconType: IconType.svg,
        onTap: onTap,
        trailing: trailing,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.icon({
    Key? key,
    required String title,
    required IconData iconData,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    Widget? trailing,
    bool enabled = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconData: iconData,
        onTap: onTap,
        trailing: trailing,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.radio({
    Key? key,
    required String title,
    required bool radioValue,
    required bool radioGroupValue,
    required ValueChanged<bool?> onRadioChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconType: IconType.radio,
        radioValue: radioValue,
        radioGroupValue: radioGroupValue,
        onRadioChanged: onRadioChanged,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.checkbox({
    Key? key,
    required String title,
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconType: IconType.checkbox,
        checkboxValue: checkboxValue,
        onCheckboxChanged: onCheckboxChanged,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.svgWithCheckbox({
    Key? key,
    required String title,
    required String iconPath,
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconData: iconPath,
        iconType: IconType.svgWithCheckbox,
        checkboxValue: checkboxValue,
        onCheckboxChanged: onCheckboxChanged,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.iconWithCheckbox({
    Key? key,
    required String title,
    required IconData iconData,
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconData: iconData,
        iconType: IconType.materialIconWithCheckbox,
        checkboxValue: checkboxValue,
        onCheckboxChanged: onCheckboxChanged,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.svgWithSwitch({
    Key? key,
    required String title,
    required String iconPath,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
    bool showSwitch = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconData: iconPath,
        iconType: IconType.svg,
        switchValue: switchValue,
        onSwitchChanged: onSwitchChanged,
        showSwitch: showSwitch,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.iconWithSwitch({
    Key? key,
    required String title,
    required IconData iconData,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
    bool showSwitch = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        iconData: iconData,
        switchValue: switchValue,
        onSwitchChanged: onSwitchChanged,
        showSwitch: showSwitch,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  factory ActionListTile.switchOnly({
    Key? key,
    required String title,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    String? subtitle,
    VoidCallback? onTap,
    ActionListTileTheme? theme,
    bool enabled = true,
    bool showSwitch = true,
  }) {
    return ActionListTile(
      key: key,
      config: ActionListTileConfig(
        title: title,
        subtitle: subtitle,
        switchValue: switchValue,
        onSwitchChanged: onSwitchChanged,
        showSwitch: showSwitch,
        onTap: onTap,
        enabled: enabled,
      ),
      theme: theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const ActionListTileTheme();
    final materialTheme = Theme.of(context);

    final textStyle = effectiveTheme.textStyle.copyWith(
      color: config.enabled
          ? effectiveTheme.textStyle.color
          : materialTheme.disabledColor,
    );

    final subtitleStyle = materialTheme.textTheme.bodySmall?.copyWith(
      color: config.enabled
          ? materialTheme.textTheme.bodySmall?.color
          : materialTheme.disabledColor,
    );

    final iconColor = config.enabled
        ? (effectiveTheme.iconColor ?? materialTheme.primaryColor)
        : materialTheme.disabledColor;

    final content = Container(
      padding: effectiveTheme.padding,
      height: config.subtitle != null
          ? effectiveTheme.containerHeight + 20
          : effectiveTheme.containerHeight,
      decoration: BoxDecoration(
        color: effectiveTheme.backgroundColor,
        borderRadius: effectiveTheme.borderRadius,
      ),
      child: Row(
        crossAxisAlignment: effectiveTheme.crossAxisAlignment,
        mainAxisAlignment: effectiveTheme.mainAxisAlignment,
        children: [
          if (config.leading != null)
            config.leading!
          else if (config.iconData != null ||
              config.iconType == IconType.radio ||
              config.iconType == IconType.checkbox ||
              config.iconType == IconType.svgWithCheckbox ||
              config.iconType == IconType.materialIconWithCheckbox)
            IconBuilder.build(
              iconType: config.iconType,
              iconData: config.iconData,
              size: effectiveTheme.iconSize,
              color: iconColor,
              radioValue: config.radioValue,
              radioGroupValue: config.radioGroupValue,
              onRadioChanged: config.onRadioChanged,
              checkboxValue: config.checkboxValue,
              onCheckboxChanged: config.onCheckboxChanged,
            ),

          if (config.leading != null ||
              config.iconData != null ||
              config.iconType == IconType.radio ||
              config.iconType == IconType.checkbox ||
              config.iconType == IconType.svgWithCheckbox ||
              config.iconType == IconType.materialIconWithCheckbox)
            SizedBox(width: effectiveTheme.iconTextGap),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  config.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                if (config.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    config.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: subtitleStyle,
                  ),
                ],
              ],
            ),
          ),

          if (config.showSwitch && config.switchValue != null) ...[
            const SizedBox(width: 8),
            AppSwitch(
              key: ValueKey(config.switchValue),
              initialValue: config.switchValue!,
              onChanged: config.enabled ? config.onSwitchChanged : null,
              enabled: config.enabled,
              switchTheme: AppSwitchTheme(),
            ),
          ] else if (config.trailing != null) ...[
            const SizedBox(width: 8),
            config.trailing!,
          ],
        ],
      ),
    );

    final keyName =
        'action_list_tile_${config.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

    return GestureWrapper(
      onTap: config.iconType == IconType.radio
          ? () => config.onRadioChanged?.call(config.radioValue)
          : config.iconType == IconType.checkbox ||
                config.iconType == IconType.svgWithCheckbox ||
                config.iconType == IconType.materialIconWithCheckbox
          ? () =>
                config.onCheckboxChanged?.call(!(config.checkboxValue ?? false))
          : config.showSwitch && config.switchValue != null
          ? () => config.onSwitchChanged?.call(!(config.switchValue!))
          : config.onTap,
      enableRipple: effectiveTheme.enableRipple,
      borderRadius: effectiveTheme.borderRadius,
      keyName: keyName,
      enabled: config.enabled,
      child: content,
    );
  }
}

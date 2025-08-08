import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../enums/icon_type.dart';

class IconBuilder {
  static Widget build({
    required IconType iconType,
    required dynamic iconData,
    required double size,
    required Color color,
    bool? radioValue,
    bool? radioGroupValue,
    ValueChanged<bool?>? onRadioChanged,
    bool? checkboxValue,
    ValueChanged<bool?>? onCheckboxChanged,
  }) {
    switch (iconType) {
      case IconType.svg:
        return SvgPicture.asset(
          iconData as String,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
        );

      case IconType.materialIcon:
        return Icon(iconData as IconData, size: size, color: color);

      case IconType.radio:
        return Radio<bool>(
          value: radioValue!,
          splashRadius: 0,
          groupValue: radioGroupValue,
          onChanged: onRadioChanged,
          activeColor: color,
        );

      case IconType.checkbox:
        return Checkbox(
          value: checkboxValue,
          onChanged: onCheckboxChanged,
          activeColor: color,
        );

      case IconType.svgWithCheckbox:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: checkboxValue,
              onChanged: onCheckboxChanged,
              activeColor: color,
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              iconData as String,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
            ),
          ],
        );

      case IconType.materialIconWithCheckbox:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: checkboxValue,
              onChanged: onCheckboxChanged,
              activeColor: color,
            ),
            const SizedBox(width: 12),
            Icon(iconData as IconData, size: size, color: color),
          ],
        );
    }
  }
}

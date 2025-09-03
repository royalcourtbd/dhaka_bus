import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../enums/dialog_icon_type.dart';

class DialogIconBuilder {
  static Widget build({
    required DialogIconType iconType,
    required dynamic iconData,
    required double size,
    Color? color,
  }) {
    switch (iconType) {
      case DialogIconType.svg:
        return SvgPicture.asset(
          iconData as String,
          width: size,
          height: size,
          colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        );

      case DialogIconType.materialIcon:
        return Icon(iconData as IconData, size: size, color: color);
    }
  }
}
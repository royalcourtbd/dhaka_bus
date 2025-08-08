import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:dhaka_bus/shared/components/svg_image.dart';

class NavDestinationItem extends StatelessWidget {
  const NavDestinationItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.outlineIcon,
    required this.fillIcon,
    required this.label,
  });

  final int index;
  final int selectedIndex;
  final String outlineIcon;
  final String fillIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: SvgImage(
        selectedIndex == index ? fillIcon : outlineIcon,
        color: context.color.primaryColor500,
      ),
      label: label,
      tooltip: '',
    );
  }
}

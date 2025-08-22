import 'package:flutter/material.dart';
import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/features/main/presentation/widgets/nav_destination_item.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sixteenPx),
      decoration: BoxDecoration(
        color: context.color.backgroundColor,
        border: Border(top: BorderSide(color: context.color.blackColor200)),
      ),
      child: NavigationBar(
        backgroundColor: context.color.backgroundColor,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavDestinationItem(
            index: 0,
            selectedIndex: selectedIndex,
            outlineIcon: SvgPath.icHomeOutline,
            fillIcon: SvgPath.icHomeFilled,

            label: 'Home',
          ),
          NavDestinationItem(
            index: 1,
            selectedIndex: selectedIndex,
            outlineIcon: SvgPath.icBusOutline,
            fillIcon: SvgPath.icBusFilled,
            label: 'Bus',
          ),

          NavDestinationItem(
            index: 2,
            selectedIndex: selectedIndex,
            outlineIcon: SvgPath.icCategoryOutline,
            fillIcon: SvgPath.icCategoryFill,
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

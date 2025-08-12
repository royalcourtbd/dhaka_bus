import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/shared/components/loading_indicator.dart';
import 'package:dhaka_bus/shared/components/skeleton_widgets/bus_route_card_skeleton.dart';
import 'package:flutter/material.dart';

class BusLoadingWidget extends StatelessWidget {
  const BusLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: twentyPx,
            vertical: sixteenPx,
          ),
          padding: padding15,
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: radius12,
            border: Border.all(color: theme.primaryColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingIndicator(),
              gapW12,
              Text(
                'Loading buses...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: paddingH20,
            itemCount: 6,
            itemBuilder: (context, index) => const BusRouteCardSkeleton(),
          ),
        ),
      ],
    );
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:flutter/material.dart';

class BusRouteCardSkeleton extends StatefulWidget {
  const BusRouteCardSkeleton({super.key});

  @override
  State<BusRouteCardSkeleton> createState() => _BusRouteCardSkeletonState();
}

class _BusRouteCardSkeletonState extends State<BusRouteCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(bottom: twelvePx),
          decoration: BoxDecoration(
            borderRadius: radius12,
            border: Border.all(color: const Color(0xffDEDEDE), width: 0.5),
          ),
          child: Container(
            padding: padding15,
            child: Row(
              children: [
                // Bus icon skeleton
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(_animation.value),
                    borderRadius: radius8,
                  ),
                ),

                const SizedBox(width: 15),

                // Text content skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bus name skeleton
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(_animation.value),
                          borderRadius: radius4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Route description skeleton
                      Container(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(_animation.value * 0.7),
                          borderRadius: radius4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Expand icon skeleton
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(_animation.value * 0.5),
                    borderRadius: radius12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/number_utility.dart';
import 'package:dhaka_bus/shared/components/ontap_widget.dart';
import 'package:flutter/material.dart';

class BusRouteCard extends StatelessWidget {
  final String id; // Unique identifier for the card
  final String title;
  final String route;
  final String description;
  final Color cardColor;
  final bool isExpanded;
  final VoidCallback onTap;

  const BusRouteCard({
    super.key,
    required this.id,
    required this.title,
    required this.route,
    required this.description,
    this.cardColor = Colors.blue,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: twelvePx),
      decoration: BoxDecoration(
        borderRadius: radius12,
        border: Border.all(color: Color(0xffDEDEDE), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: OnTapWidget(
          borderRadius: twelvePx,
          onTap: onTap,
          child: AnimatedContainer(
            duration: 300.inMilliseconds,
            curve: Curves.easeInOut,
            child: Padding(
              padding: padding15,
              child: Column(
                children: [
                  // Main Card Content
                  Row(
                    children: [
                      // Bus Icon
                      Container(
                        width: fiftyPx,
                        height: fiftyPx,
                        decoration: BoxDecoration(
                          color: cardColor.withValues(alpha: 0.1),
                          borderRadius: radius8,
                        ),
                        child: Icon(
                          Icons.directions_bus,
                          color: cardColor,
                          size: twentyFourPx,
                        ),
                      ),
                      gapW16,

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontSize: sixteenPx,
                                    color: cardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            gapH4,

                            // Route
                            Text(
                              route,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: fourteenPx,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon with Animation
                      AnimatedRotation(
                        turns: isExpanded ? 0.25 : 0,
                        duration: 350.inMilliseconds,
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey[400],
                          size: twentyFourPx,
                        ),
                      ),
                    ],
                  ),

                  // Expandable Content with smooth animation
                  ClipRect(
                    child: AnimatedSize(
                      duration: 350.inMilliseconds,
                      curve: Curves.easeInOutCubic,
                      child: AnimatedContainer(
                        duration: 350.inMilliseconds,
                        curve: Curves.easeInOutCubic,
                        height: isExpanded ? null : 0,
                        child: AnimatedOpacity(
                          duration: 250.inMilliseconds,
                          opacity: isExpanded ? 1.0 : 0.0,
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Padding(
                                  padding: paddingTop20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Route Details
                                      _buildDetailRow(
                                        icon: Icons.route,
                                        title: 'রুটের বিস্তারিত:',
                                        content: description,
                                      ),

                                      gapH8,
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: sixteenPx, color: cardColor),
        gapW8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cardColor,
                ),
              ),
              gapH2,
              Text(
                content,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

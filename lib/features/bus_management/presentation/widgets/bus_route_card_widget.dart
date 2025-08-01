import 'package:flutter/material.dart';

class BusRouteCard extends StatelessWidget {
  final String id; // Unique identifier for the card
  final String title;
  final String route;
  final String description;
  final Color cardColor;
  final String busTime;
  final String fare;
  final bool isExpanded;
  final VoidCallback onTap;

  const BusRouteCard({
    super.key,
    required this.id,
    required this.title,
    required this.route,
    required this.description,
    this.cardColor = Colors.blue,
    required this.busTime,
    required this.fare,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffDEDEDE), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Main Card Content
                  Row(
                    children: [
                      // Bus Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.directions_bus,
                          color: cardColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: cardColor,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Route
                            Text(
                              route,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon with Animation
                      AnimatedRotation(
                        turns: isExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  // Expandable Content with smooth animation
                  ClipRect(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOutCubic,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                        height: isExpanded ? null : 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isExpanded ? 1.0 : 0.0,
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16),
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
                                      const SizedBox(height: 12),

                                      // Time Information
                                      _buildDetailRow(
                                        icon: Icons.access_time,
                                        title: 'সময়সূচি:',
                                        content: busTime,
                                      ),
                                      const SizedBox(height: 12),

                                      // Fare Information
                                      _buildDetailRow(
                                        icon: Icons.payments,
                                        title: 'ভাড়া:',
                                        content: fare,
                                      ),
                                      const SizedBox(height: 8),
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
        Icon(icon, size: 16, color: cardColor),
        const SizedBox(width: 8),
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
              const SizedBox(height: 2),
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

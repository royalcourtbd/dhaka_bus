import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/shared/components/ontap_widget.dart';
import 'package:flutter/material.dart';

class BusRouteCard extends StatelessWidget {
  final String route;
  final String description;
  final Color cardColor;
  final bool isExpanded;
  final VoidCallback onTap;
  final BusEntity bus;

  const BusRouteCard({
    super.key,
    required this.route,
    required this.description,
    this.cardColor = Colors.blue,
    required this.isExpanded,
    required this.onTap,
    required this.bus,
  });

  // Cache commonly used values and colors for better performance
  static const double _iconContainerSize = 50.0;
  static const double _borderWidth = 0.5;
  static const Color _borderColor = Color(0xffDEDEDE);
  static const Color _expandedTextColor = Color(0xff888888);
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _rotationDuration = Duration(milliseconds: 350);
  static const Duration _opacityDuration = Duration(milliseconds: 250);
  static const int _maxTitleLines = 1;
  static const double _textHeight = 1.4;
  static const double _expandedTextHeight = 1.6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBackgroundColor = cardColor.withValues(alpha: 0.1);

    return Container(
      margin: EdgeInsets.only(bottom: twelvePx),
      decoration: BoxDecoration(
        borderRadius: radius12,
        border: Border.all(color: _borderColor, width: _borderWidth),
      ),
      child: Material(
        color: Colors.transparent,
        child: OnTapWidget(
          borderRadius: twelvePx,
          onTap: onTap,
          child: AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            child: Padding(
              padding: padding15,
              child: Column(
                children: [
                  _buildMainCardContent(theme, cardBackgroundColor),
                  _buildExpandableContent(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCardContent(ThemeData theme, Color cardBackgroundColor) {
    return Row(
      children: [
        _buildBusIcon(cardBackgroundColor),
        gapW16,
        _buildContentSection(theme),
        _buildArrowIcon(),
      ],
    );
  }

  Widget _buildBusIcon(Color backgroundColor) {
    return Container(
      width: _iconContainerSize,
      height: _iconContainerSize,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: radius8),
      child: Icon(Icons.directions_bus, color: cardColor, size: twentyFourPx),
    );
  }

  Widget _buildContentSection(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bus.busNameEn,
            maxLines: _maxTitleLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: sixteenPx,
              color: cardColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          gapH4,
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: fourteenPx,
              color: Colors.grey[700],
              height: _textHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowIcon() {
    return AnimatedRotation(
      turns: isExpanded ? 0.25 : 0,
      duration: _rotationDuration,
      curve: Curves.easeInOutCubic,
      child: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.grey[400],
        size: twentyFourPx,
      ),
    );
  }

  Widget _buildExpandableContent(ThemeData theme) {
    return ClipRect(
      child: AnimatedSize(
        duration: _rotationDuration,
        curve: Curves.easeInOutCubic,
        child: AnimatedContainer(
          duration: _rotationDuration,
          curve: Curves.easeInOutCubic,
          height: isExpanded ? null : 0,
          child: AnimatedOpacity(
            duration: _opacityDuration,
            opacity: isExpanded ? 1.0 : 0.0,
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    padding: paddingTop20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        route,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: twelvePx,
                          color: _expandedTextColor,
                          height: _expandedTextHeight,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/shared/components/ontap_widget.dart';
import 'package:flutter/material.dart';

class BusRouteCard extends StatelessWidget {
  final String route;
  final String description;
  final Color? cardColor; // Made nullable to use primary color as default
  final bool isExpanded;
  final VoidCallback onTap;
  final BusEntity bus;
  final String? originStop;
  final String? destinationStop;

  const BusRouteCard({
    super.key,
    required this.route,
    required this.description,
    this.cardColor, // No default value here
    required this.isExpanded,
    required this.onTap,
    required this.bus,
    this.originStop,
    this.destinationStop,
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
    // Use primary color if cardColor is not provided
    final Color effectiveCardColor = cardColor ?? theme.colorScheme.primary;
    final cardBackgroundColor = effectiveCardColor.withValues(alpha: 0.1);

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
                  _buildMainCardContent(
                    theme,
                    cardBackgroundColor,
                    effectiveCardColor,
                  ),
                  _buildExpandableContent(theme, effectiveCardColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCardContent(
    ThemeData theme,
    Color cardBackgroundColor,
    Color effectiveCardColor,
  ) {
    return Row(
      children: [
        _buildBusIcon(cardBackgroundColor, effectiveCardColor),
        gapW16,
        _buildContentSection(theme, effectiveCardColor),
        _buildArrowIcon(),
      ],
    );
  }

  Widget _buildBusIcon(Color backgroundColor, Color iconColor) {
    return Container(
      width: _iconContainerSize,
      height: _iconContainerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: radius8),
      child: Text(bus.busId),
    );
  }

  Widget _buildContentSection(ThemeData theme, Color titleColor) {
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
              color: titleColor,
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

  Widget _buildExpandableContent(ThemeData theme, Color highlightColor) {
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
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: _buildHighlightedRouteText(theme, highlightColor),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  /// Builds the text for the expanded route view, highlighting the
  /// origin and destination stops if a search is active.
  InlineSpan _buildHighlightedRouteText(ThemeData theme, Color highlightColor) {
    final bool hasHighlight =
        originStop != null &&
        originStop!.isNotEmpty &&
        destinationStop != null &&
        destinationStop!.isNotEmpty;

    // Return plain text if no highlighting is needed or route is unavailable
    if (!hasHighlight || route.contains('Not Available')) {
      return TextSpan(
        text: route,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: twelvePx,
          color: _expandedTextColor,
          height: _expandedTextHeight,
        ),
      );
    }

    final List<String> stops = route.split(' → ');
    final List<InlineSpan> textSpans = [];

    final TextStyle normalStyle = theme.textTheme.bodyMedium!.copyWith(
      fontSize: twelvePx,
      color: _expandedTextColor,
      height: _expandedTextHeight,
    );

    final TextStyle highlightStyle = normalStyle.copyWith(
      fontWeight: FontWeight.w900,
      color: highlightColor,
    );

    for (int i = 0; i < stops.length; i++) {
      final String stop = stops[i];
      // Case-insensitive check for highlighting
      final bool isHighlighted =
          stop.toLowerCase() == originStop!.toLowerCase() ||
          stop.toLowerCase() == destinationStop!.toLowerCase();

      textSpans.add(
        TextSpan(
          text: stop,
          style: isHighlighted ? highlightStyle : normalStyle,
        ),
      );

      // Add the arrow separator if it's not the last stop
      if (i < stops.length - 1) {
        textSpans.add(TextSpan(text: ' → ', style: normalStyle));
      }
    }

    return TextSpan(children: textSpans);
  }
}

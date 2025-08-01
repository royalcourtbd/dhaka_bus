import 'dart:math';
import 'package:flutter/material.dart';

class DashedCircularProgressBar extends StatelessWidget {
  /// Progress bar width.
  final double width;

  /// Progress bar height.
  final double height;

  /// Progress aspect ratio.
  final double aspectRatio;

  /// Current value of progress bar.
  final double progress;

  /// Maximum value of progress.
  final double maxProgress;

  /// The starting angle of the arc should be between 0 and 360.
  final double startAngle;

  /// The end angle of the arc should be between 0 and 360.
  final double sweepAngle;

  /// Foreground arc thickness.
  final double foregroundStrokeWidth;

  /// Background arc thickness.
  final double backgroundStrokeWidth;

  /// Foreground arc color.
  final Color foregroundColor;

  /// Background arc thickness.
  final Color backgroundColor;

  /// Styles to use for arcs endings.
  final StrokeCap corners;

  /// Foreground arc gap size.
  final double foregroundGapSize;

  /// Background arc gap size.
  final double backgroundGapSize;

  /// Progress bar seek size.
  final double seekSize;

  /// Progress bar seek color.
  final Color seekColor;

  /// Align center of progress bar.
  final Alignment circleCenterAlignment;

  /// Active progress bar animation.
  final bool animation;

  /// Progress bar animation duration.
  final Duration animationDuration;

  /// Progress bar animation curve.
  final Curve animationCurve;

  /// This function is called when animation ended.
  final void Function()? onAnimationEnd;

  /// Specifies how to draw arcs from right to left or vice versa.
  /// In fact, if [ ltr ] == false, it flip the widget horizontally.
  final bool ltr;

  /// This widget is placed on the progress bar.
  final Widget? child;

  /// Animated value notifier.
  final ValueNotifier<double>? valueNotifier;

  /// Create progress bar depend.
  const DashedCircularProgressBar({
    super.key,
    required this.width,
    required this.height,
    this.progress = 0,
    this.maxProgress = 100,
    this.startAngle = 0,
    this.sweepAngle = 360,
    this.foregroundStrokeWidth = 2,
    this.backgroundStrokeWidth = 2,
    this.foregroundColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.corners = StrokeCap.round,
    this.foregroundGapSize = 0,
    this.backgroundGapSize = 0,
    this.seekSize = 0,
    this.seekColor = Colors.blue,
    this.circleCenterAlignment = Alignment.center,
    this.animation = false,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeOut,
    this.onAnimationEnd,
    this.ltr = true,
    this.child,
    this.valueNotifier,
  }) : aspectRatio = 0;

  /// Create square progress bar depend on dimensions.
  const DashedCircularProgressBar.square({
    super.key,
    required double dimensions,
    this.progress = 0,
    this.maxProgress = 100,
    this.startAngle = 0,
    this.sweepAngle = 360,
    this.foregroundStrokeWidth = 2,
    this.backgroundStrokeWidth = 2,
    this.foregroundColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.corners = StrokeCap.round,
    this.foregroundGapSize = 0,
    this.backgroundGapSize = 0,
    this.seekSize = 0,
    this.seekColor = Colors.blue,
    this.circleCenterAlignment = Alignment.center,
    this.animation = false,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeOut,
    this.onAnimationEnd,
    this.ltr = true,
    this.child,
    this.valueNotifier,
  }) : aspectRatio = 0,
       width = dimensions,
       height = dimensions;

  /// Create progress bar depend on aspect ratio.
  const DashedCircularProgressBar.aspectRatio({
    super.key,
    required this.aspectRatio,
    this.progress = 0,
    this.maxProgress = 100,
    this.startAngle = 0,
    this.sweepAngle = 360,
    this.foregroundStrokeWidth = 2,
    this.backgroundStrokeWidth = 2,
    this.foregroundColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.corners = StrokeCap.round,
    this.foregroundGapSize = 0,
    this.backgroundGapSize = 0,
    this.seekSize = 0,
    this.seekColor = Colors.blue,
    this.circleCenterAlignment = Alignment.center,
    this.animation = false,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeOut,
    this.onAnimationEnd,
    this.ltr = true,
    this.child,
    this.valueNotifier,
  }) : width = 0,
       height = 0;

  @override
  Widget build(BuildContext context) {
    if (aspectRatio != 0) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: _flipHorizontal(_buildProgressBar()),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: _flipHorizontal(_buildProgressBar()),
      );
    }
  }

  Widget _buildProgressBar() {
    // Check for animation status.
    // If allowed to use animation.
    if (animation) {
      return TweenAnimationBuilder(
        duration: animationDuration,
        tween: Tween<double>(begin: 0, end: progress),
        curve: animationCurve,
        onEnd: onAnimationEnd,
        builder: (BuildContext context, double animatedProgress, _) {
          // Notify valueNotifier if it is not null.
          valueNotifier?.value = animatedProgress;
          // Create widget.
          return CustomPaint(
            foregroundPainter: _buildPainter(animatedProgress),
            child: (child != null) ? _flipHorizontal(child!) : null,
            // child: (childBuilder != null)? childBuilder!(context, animatedProgress) : null
          );
        },
      );
    }
    // If not allowed to use animation.
    else {
      // Create widget.
      return CustomPaint(
        foregroundPainter: _buildPainter(progress),
        child: (child != null) ? _flipHorizontal(child!) : null,
      );
    }
  }

  // Build progress bar painter.
  _CircularProgressBarPainter _buildPainter(double progress) {
    // Create painter.
    return _CircularProgressBarPainter(
      progress: progress,
      maxProgress: maxProgress,
      sweepAngle: sweepAngle,
      startAngle: startAngle,
      foregroundStrokeWidth: foregroundStrokeWidth,
      backgroundStrokeWidth: backgroundStrokeWidth,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      foregroundGapSize: foregroundGapSize,
      backgroundGapSize: backgroundGapSize,
      seekSize: seekSize,
      corners: corners,
      seekColor: seekColor,
      circleCenterAlignment: circleCenterAlignment,
    );
  }

  Widget _flipHorizontal(Widget child) {
    // Check for layout direction.
    // If ltr equal true.
    if (ltr) {
      return child;
    }
    // If ltr equal false.
    else {
      // Then flip progress bar horizontally.
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: child,
      );
    }
  }
}

class _CircularProgressBarPainter extends CustomPainter {
  /// Current value of progress bar.
  final double progress;

  /// Maximum value of progress.
  final double maxProgress;

  /// The starting angle of the arc.
  final double startAngle;

  /// The sweep angle of the arc.
  final double sweepAngle;

  /// Foreground arc thickness.
  final double foregroundStrokeWidth;

  /// Background arc thickness.
  final double backgroundStrokeWidth;

  /// Foreground arc color.
  final Color foregroundColor;

  /// Background arc thickness.
  final Color backgroundColor;

  /// Styles to use for arcs endings.
  final StrokeCap corners;

  /// Foreground arc gap size.
  final double foregroundGapSize;

  /// Background arc gap size.
  final double backgroundGapSize;

  /// Progress bar seek size.
  final double seekSize;

  /// Progress bar seek color.
  final Color seekColor;

  /// Center of progress bar.
  final Alignment circleCenterAlignment;

  // Constructor
  const _CircularProgressBarPainter({
    required this.progress,
    required this.maxProgress,
    required this.sweepAngle,
    required this.startAngle,
    required this.foregroundStrokeWidth,
    required this.backgroundStrokeWidth,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.corners,
    required this.foregroundGapSize,
    required this.backgroundGapSize,
    required this.seekSize,
    required this.seekColor,
    required this.circleCenterAlignment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background circle style.
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = backgroundStrokeWidth
      ..color = backgroundColor
      ..strokeCap = corners;

    // Foreground circle style.
    Paint foregroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = foregroundStrokeWidth
      ..color = foregroundColor
      ..strokeCap = corners;

    // Calculate require values.
    // Center of progress bar.
    Point<double> centerPoint = _getCenterPoint(size);
    // Progress bar radius.
    double minEdge = (circleCenterAlignment == Alignment.center)
        ? min(size.width, size.height) / 2
        : min(size.width, size.height);
    double radius =
        minEdge - (max(foregroundStrokeWidth, backgroundStrokeWidth) / 2);
    // Arcs starting angle in radian.
    double startAngleRadian = _degreeToRadian(startAngle - 90);
    // Arcs end angle in radian.
    double sweepAngleRadian = _degreeToRadian(_percentageToDegree(progress));
    // Center point of canvas.
    Offset center = Offset(centerPoint.x, centerPoint.y);
    Rect rect = Rect.fromCircle(center: center, radius: radius);

    double backgroundSweepAngle = _degreeToRadian(sweepAngle);
    double dashSize = _calculateDashSize(
      startAngleRadian,
      backgroundSweepAngle,
      maxProgress,
    );

    // Draw background circle.
    if (backgroundGapSize > 0) {
      // Draw dashed arc for background with maxProgress segments
      _drawDashedArc(
        canvas,
        rect,
        startAngleRadian,
        backgroundSweepAngle,
        backgroundPaint,
        dashSize,
        maxProgress,
      );
    } else {
      if (sweepAngle >= 360) {
        // Draw regular circle.
        canvas.drawCircle(center, radius, backgroundPaint);
      } else {
        // Draw regular arc.
        double backgroundSweepAngle = _degreeToRadian(sweepAngle);
        canvas.drawArc(
          rect,
          startAngleRadian,
          backgroundSweepAngle,
          false,
          backgroundPaint,
        );
      }
    }

    // Draw foreground circle.
    if (foregroundGapSize > 0) {
      // Draw dashed arc for foreground with progress segments
      _drawDashedArc(
        canvas,
        rect,
        startAngleRadian,
        sweepAngleRadian,
        foregroundPaint,
        dashSize,
        progress,
      );
    } else {
      // Draw regular arc.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngleRadian,
        sweepAngleRadian,
        false,
        foregroundPaint,
      );
    }

    // Draw seek circle.
    if (seekSize > 0) {
      // Seek style.
      Paint circlePaint = Paint()
        ..strokeWidth = seekSize
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = seekColor;

      // Calculate seek size.
      double circleSize = _degreeToRadian((seekSize * 2) / 1000);
      // Draw seek.
      canvas.drawArc(
        rect,
        startAngleRadian + sweepAngleRadian,
        circleSize,
        false,
        circlePaint,
      );
    }
  }

  // This method draw multiple dash to create a dashed arc.
  void _drawDashedArc(
    Canvas canvas,
    Rect rect,
    double startAngleRadian,
    double sweepAngleRadian,
    Paint paint,
    double dashSize,
    double maxProgress,
  ) {
    // Calculate total segment size
    double segmentSweep = sweepAngleRadian / maxProgress;

    // Draw dashes for each segment
    for (int i = 0; i < maxProgress.toInt(); i++) {
      // Calculate start angle for this segment
      double segmentStartAngle = startAngleRadian + (i * segmentSweep);

      // Draw dash within the segment
      canvas.drawArc(rect, segmentStartAngle, dashSize, false, paint);
    }
  }

  double _calculateDashSize(
    double startAngleRadian,
    double sweepAngleRadian,
    double maxProgress,
  ) {
    double segmentSweep = sweepAngleRadian / maxProgress;

    double dashSizeControl = 1;

    if (maxProgress == 2) {
      dashSizeControl = 0.8;
    } else if (maxProgress > 2 && maxProgress <= 7) {
      dashSizeControl = (1 / log(maxProgress + 2));
    } else if (maxProgress > 7 && maxProgress <= 10) {
      dashSizeControl = (1 / log(maxProgress + 4));
    } else if (maxProgress > 10) {
      dashSizeControl = 0.2;
    }

    // Calculate dash size dynamically
    // Larger maxProgress results in smaller dash size
    // Uses a logarithmic approach to reduce dash size
    double dashSize = segmentSweep * dashSizeControl;
    return dashSize;
  }

  Point<double> _getCenterPoint(Size size) {
    // Calculate half of width/height size.
    double hw = size.width / 2;
    double hh = size.height / 2;

    // Determine the coordinates of the center of the progress bar.
    // Top
    if (circleCenterAlignment == Alignment.topLeft) return const Point(0, 0);
    if (circleCenterAlignment == Alignment.topCenter) return Point(hw, 0);
    if (circleCenterAlignment == Alignment.topRight) {
      return Point(size.width, 0);
    }
    // Center
    if (circleCenterAlignment == Alignment.centerLeft) return Point(0, hh);
    if (circleCenterAlignment == Alignment.center) return Point(hw, hh);
    if (circleCenterAlignment == Alignment.centerRight) {
      return Point(size.width, hh);
    }
    // Bottom
    if (circleCenterAlignment == Alignment.bottomLeft) {
      return Point(0, size.height);
    }
    if (circleCenterAlignment == Alignment.bottomCenter) {
      return Point(hw, size.height);
    }
    if (circleCenterAlignment == Alignment.bottomRight) {
      return Point(size.width, size.height);
    }
    // Default
    return const Point(0, 0);
  }

  @override
  bool shouldRepaint(covariant _CircularProgressBarPainter oldDelegate) =>
      oldDelegate.progress != progress;

  // Convert Degree to Radian
  double _degreeToRadian(double angle) => angle * pi / 180;
  // Convert Percentage to Degree
  double _percentageToDegree(double p) => (p * sweepAngle) / maxProgress;
}

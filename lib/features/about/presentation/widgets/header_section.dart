import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/config/app_theme_color.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppThemeColor appThemeColor = context.color;
    final TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        // App Icon
        Container(
          width: eightyPx,
          height: eightyPx,
          decoration: BoxDecoration(
            color: appThemeColor.primaryColor100,
            borderRadius: BorderRadius.circular(sixteenPx),
          ),
          child: Image.asset(SvgPath.imgLogo),
        ),
        gapH16,

        // App Name
        Text(
          'Dhaka Bus Route – ঢাকা বাস রুট',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: appThemeColor.primaryColor,
          ),
        ),

        SizedBox(height: eightPx),

        // App Tagline
        Text(
          'Dhaka Bus - Your Reliable Travel Companion',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

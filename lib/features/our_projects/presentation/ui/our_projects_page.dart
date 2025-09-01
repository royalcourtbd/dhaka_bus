import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/config/app_color.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:dhaka_bus/shared/components/submit_button.dart';
import 'package:dhaka_bus/shared/components/svg_image.dart';
import 'package:flutter/material.dart';

class OurProjectsPage extends StatelessWidget {
  const OurProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Our Projects'),
      body: SingleChildScrollView(
        padding: paddingH16.copyWith(top: twentyPx, bottom: twentyPx),
        child: Column(
          children: [
            _buildProjectCard(
              context,
              icon: Icons.directions_bus,
              title: 'Dhaka Bus Official Website',
              subtitle: 'Dhaka Bus Foundation',
              description:
                  'Visit our official website now to obtain information about our ongoing app projects and services.',
              websiteUrl: 'https://www.dhakabus.com',
            ),
            SizedBox(height: sixteenPx),
            _buildProjectCard(
              context,
              icon: Icons.route,
              title: 'Dhaka Bus Routes',
              subtitle: 'Dhaka Bus Foundation',
              description:
                  'Discover all bus routes in Dhaka, including live tracking, fare details, and estimated arrival times.',
              appDownloadUrl:
                  'https://play.google.com/store/apps/details?id=com.dhakabus.routes',
              websiteUrl: 'https://routes.dhakabus.com',
            ),
            SizedBox(height: sixteenPx),
            _buildProjectCard(
              context,
              icon: Icons.calendar_today,
              title: 'Dhaka Bus Schedule',
              subtitle: 'Dhaka Bus Foundation',
              description:
                  'Get real-time schedules for all bus lines, plan your journey, and avoid waiting. ',
              appDownloadUrl:
                  'https://play.google.com/store/apps/details?id=com.dhakabus.schedule',
              websiteUrl: 'https://schedule.dhakabus.com',
            ),
            SizedBox(height: sixteenPx),
            _buildProjectCard(
              context,
              icon: Icons.feedback,
              title: 'Dhaka Bus Feedback',
              subtitle: 'Dhaka Bus Foundation',
              description:
                  'Share your experience, report issues, and suggest improvements to help us enhance our services.',
              websiteUrl: 'https://feedback.dhakabus.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    String? appDownloadUrl,
    String? websiteUrl,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: radius12),
      color: AppColor.backgroundColor,
      child: Padding(
        padding: paddingH16.copyWith(top: twentyPx, bottom: twentyPx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(twelvePx),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor50,
                    borderRadius: radius10,
                  ),
                  child: Icon(
                    icon,
                    color: AppColor.primaryColor500,
                    size: thirtyPx,
                  ),
                ),
                SizedBox(width: sixteenPx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: eighteenPx,
                          fontWeight: FontWeight.w600,
                          color: AppColor.titleColor,
                        ),
                      ),
                      SizedBox(height: fourPx),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: fourteenPx,
                          color: AppColor.subTitleColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: sixteenPx),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: fifteenPx,
                color: AppColor.bodyColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: twentyPx),
            Row(
              children: [
                if (appDownloadUrl != null)
                  Expanded(
                    child: SubmitButton(
                      title: 'Download App',
                      theme: theme,
                      buttonColor: context.color.primaryColor100,
                      onTap: () => print('Download App: $appDownloadUrl'),
                      svgPicture: SvgImage(SvgPath.icPlayStore),
                    ),
                  ),
                if (appDownloadUrl != null && websiteUrl != null)
                  SizedBox(width: twelvePx),
                if (websiteUrl != null)
                  Expanded(
                    child: SubmitButton(
                      title: 'Visit Website',
                      theme: theme,
                      buttonColor: context.color.primaryColor100,
                      onTap: () => print('Visit Website: $websiteUrl'),
                      svgPicture: SvgImage(SvgPath.icPlayStore),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

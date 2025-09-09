import 'package:dhaka_bus/core/config/app_color.dart';
import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/our_project/presentation/widgets/project_card_buttons.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.icon,
    required this.appName,
    required this.companyName,
    required this.description,
    this.appDownloadUrl,
    this.websiteUrl,
  });

  final IconData icon;
  final String appName;
  final String companyName;
  final String description;
  final String? appDownloadUrl;
  final String? websiteUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: radius12),

      child: Padding(
        padding: padding14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: padding12,
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
                gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: eighteenPx,
                          fontWeight: FontWeight.w600,
                          color: AppColor.titleColor,
                        ),
                      ),
                      gapH4,
                      Text(
                        companyName,
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
            gapH16,
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: fifteenPx,
                color: AppColor.bodyColor,
                height: 1.5,
              ),
            ),
            if (appDownloadUrl != null || websiteUrl != null) ...[
              gapH20,
              ProjectCardButtons(
                appDownloadUrl: appDownloadUrl,
                websiteUrl: websiteUrl,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

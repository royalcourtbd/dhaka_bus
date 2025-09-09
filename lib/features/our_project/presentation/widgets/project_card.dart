import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
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
                    color: context.color.primaryColor50,
                    borderRadius: radius10,
                  ),
                  child: Icon(
                    icon,
                    color: context.color.primaryColor,
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
                          color: context.color.titleColor,
                        ),
                      ),
                      gapH4,
                      Text(
                        companyName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: fourteenPx,
                          color: context.color.subTitleColor,
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
                color: context.color.bodyColor,
                height: 1.5,
              ),
            ),
            if (appDownloadUrl != null || websiteUrl != null) ...[
              gapH20,
              RepaintBoundary(
                child: ProjectCardButtons(
                  appDownloadUrl: appDownloadUrl,
                  websiteUrl: websiteUrl,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:dhaka_bus/core/services/launcher_service.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/our_project/presentation/widgets/download_button.dart';
import 'package:flutter/material.dart';

class ProjectCardButtons extends StatelessWidget {
  const ProjectCardButtons({super.key, this.appDownloadUrl, this.websiteUrl});

  final String? appDownloadUrl;
  final String? websiteUrl;

  @override
  Widget build(BuildContext context) {
    final bool hasWebsite = websiteUrl?.isNotEmpty ?? false;
    final bool hasAppDownload = appDownloadUrl?.isNotEmpty ?? false;

    if (!hasWebsite && !hasAppDownload) {
      return const SizedBox.shrink();
    }

    if (hasWebsite && hasAppDownload) {
      // Show both buttons
      return Row(
        children: [
          Expanded(
            child: DownloadButton(
              buttonTitle: 'Download App',
              isDownload: true,
              onTap: () => _handleButtonTap(url: appDownloadUrl),
            ),
          ),
          gapW12,
          Expanded(
            child: DownloadButton(
              buttonTitle: 'Visit Website',
              isDownload: false,
              onTap: () => _handleButtonTap(url: websiteUrl),
            ),
          ),
        ],
      );
    } else if (hasWebsite) {
      // Show only website button
      return DownloadButton(
        buttonTitle: 'Visit Website',
        isDownload: false,
        onTap: () => _handleButtonTap(url: websiteUrl),
      );
    } else {
      // Show only download button
      return DownloadButton(
        buttonTitle: 'Download App',
        isDownload: true,
        onTap: () => _handleButtonTap(url: appDownloadUrl),
      );
    }
  }

  void _handleButtonTap({String? url}) {
    if (url != null && url.isNotEmpty) {
      openUrl(url: url);
    }
  }
}

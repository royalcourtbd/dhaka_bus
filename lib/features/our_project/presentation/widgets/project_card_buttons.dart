import 'package:dhaka_bus/core/services/launcher_service.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/shared/components/submit_button.dart';
import 'package:dhaka_bus/shared/components/svg_image.dart';
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
      return Row(
        children: [
          Expanded(
            child: RepaintBoundary(
              child: _DownloadButton(
                buttonTitle: 'Download App',
                isDownload: true,
                onTap: () => _handleButtonTap(url: appDownloadUrl),
              ),
            ),
          ),
          gapW12,
          Expanded(
            child: RepaintBoundary(
              child: _DownloadButton(
                buttonTitle: 'Visit Website',
                isDownload: false,
                onTap: () => _handleButtonTap(url: websiteUrl),
              ),
            ),
          ),
        ],
      );
    } else if (hasWebsite) {
      // Show only website button
      return RepaintBoundary(
        child: _DownloadButton(
          buttonTitle: 'Visit Website',
          isDownload: false,
          onTap: () => _handleButtonTap(url: websiteUrl),
        ),
      );
    } else {
      // Show only download button
      return RepaintBoundary(
        child: _DownloadButton(
          buttonTitle: 'Download App',
          isDownload: true,
          onTap: () => _handleButtonTap(url: appDownloadUrl),
        ),
      );
    }
  }

  void _handleButtonTap({String? url}) {
    if (url != null && url.isNotEmpty) {
      openUrl(url: url);
    }
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    required this.buttonTitle,
    required this.isDownload,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String buttonTitle;
  final bool isDownload;

  @override
  Widget build(BuildContext context) {
    return SubmitButton(
      title: buttonTitle,
      theme: Theme.of(context),
      onTap: onTap,
      buttonColor: context.color.primaryColor25,
      svgPicture: SvgImage(
        isDownload ? SvgPath.icDownloadCircle : SvgPath.icLink,
        color: context.color.primaryColor,
      ),
    );
  }
}

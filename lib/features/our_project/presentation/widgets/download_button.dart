import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/shared/components/submit_button.dart';
import 'package:dhaka_bus/shared/components/svg_image.dart';
import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
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

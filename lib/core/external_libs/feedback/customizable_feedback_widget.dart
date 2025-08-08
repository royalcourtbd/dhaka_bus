import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomizableFeedbackWidget extends StatelessWidget {
  final String messageTitle;
  final String? messageDescription;
  final String? svgPath;

  const CustomizableFeedbackWidget({
    super.key,
    required this.messageTitle,
    this.svgPath,
    this.messageDescription,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screen = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgPath != null) ...[
            SvgPicture.asset(svgPath!, height: screen.width * .45),
            const SizedBox(height: 16),
          ],
          Text(
            messageTitle,
            style: theme.textTheme.titleLarge!.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (messageDescription != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                messageDescription!,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

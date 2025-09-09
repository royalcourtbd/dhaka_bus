import 'package:dhaka_bus/core/static/constants.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/our_project/presentation/widgets/project_card.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class OurProjectPage extends StatelessWidget {
  const OurProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Our Projects'),
      body: SingleChildScrollView(
        padding: padding15,
        child: Column(
          children: [
            RepaintBoundary(
              child: ProjectCard(
                icon: Icons.route,
                appName: 'Royal Court BD',
                companyName: companyName,
                description:
                    'Visit our official website now to obtain information about our ongoing app projects and services.',
                websiteUrl: websiteUrl,
              ),
            ),
            gapH16,
            RepaintBoundary(
              child: ProjectCard(
                icon: Icons.directions_bus,
                appName: 'Dhaka Bus (ঢাকা বাস)',
                companyName: companyName,
                description: 'Discover all bus routes in Dhaka',
                appDownloadUrl: playStoreUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

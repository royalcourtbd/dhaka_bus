import 'package:dhaka_bus/core/config/app_screen.dart';
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
        padding: paddingH16.copyWith(top: twentyPx, bottom: twentyPx),
        child: Column(
          children: [
            ProjectCard(
              icon: Icons.directions_bus,
              appName: 'Royal Court BD',
              companyName: companyName,
              description:
                  'Visit our official website now to obtain information about our ongoing app projects and services.',
              websiteUrl: websiteUrl,
              // appDownloadUrl: 'd hgdfkh f h',
            ),
            SizedBox(height: sixteenPx),
            ProjectCard(
              icon: Icons.route,
              appName: 'Dhaka Bus (ঢাকা বাস)',
              companyName: companyName,
              description:
                  'Discover all bus routes in Dhaka, including live tracking, fare details, and estimated arrival times.',
              appDownloadUrl:
                  'https://play.google.com/store/apps/details?id=com.dhakabus.routes',
            ),
          ],
        ),
      ),
    );
  }
}

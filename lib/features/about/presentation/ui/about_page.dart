import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/static/constants.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/about/presentation/presenter/about_presenter.dart';
import 'package:dhaka_bus/features/about/presentation/widgets/header_section.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final AboutPresenter _presenter = locate<AboutPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: _presenter,
      builder: () => Scaffold(
        appBar: CustomAppBar(title: 'About Dhaka Bus', centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(sixteenPx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo and Name
              HeaderSection(),

              SizedBox(height: thirtyTwoPx),

              // App Description
              _buildAppDescription(context),

              SizedBox(height: thirtyTwoPx),

              // Features Section
              _buildFeaturesList(context),

              SizedBox(height: thirtyTwoPx),

              // App Information
              _buildAppInfo(context),

              SizedBox(height: thirtyTwoPx),

              // Developer Information
              _buildDeveloperInfo(context),

              SizedBox(height: twentyFourPx),

              // Contact Section
              _buildContactSection(context),

              SizedBox(height: thirtyTwoPx),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sixteenPx),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(twelvePx),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: twelvePx),
          Text(
            'Dhaka Bus is a comprehensive digital guide for the bus transportation system of Dhaka city. This app helps passengers easily find bus routes and plan their journeys.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = [
      {
        'icon': Icons.route,
        'title': 'All Bus Routes',
        'desc': 'Complete bus route information for Dhaka city',
      },
      {
        'icon': Icons.location_on,
        'title': 'Bus Stops',
        'desc': 'Exact locations of all bus stops',
      },
      {
        'icon': Icons.search,
        'title': 'Easy Search',
        'desc': 'Quick and easy bus route finding facility',
      },
      {
        'icon': Icons.directions,
        'title': 'Trip Planning',
        'desc': 'Best route suggestions according to destination',
      },
      {
        'icon': Icons.offline_pin,
        'title': 'Offline Support',
        'desc': 'Use without internet connection',
      },
    ];

    return Container(
      padding: EdgeInsets.all(sixteenPx),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(twelvePx),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sixteenPx),
          ...features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: twelvePx),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(eightPx),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(eightPx),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: Theme.of(context).primaryColor,
                      size: twentyFourPx,
                    ),
                  ),
                  SizedBox(width: twelvePx),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          feature['desc'] as String,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sixteenPx),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(twelvePx),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            'Version',
            _presenter.currentUiState.appVersion,
          ),
          Divider(height: twentyFourPx),
          _buildInfoRow(context, 'Package Name', 'com.royalcourtbd.dhaka_bus'),
          Divider(height: twentyFourPx),
          _buildInfoRow(context, 'Last Updated', 'August 2024'),
          Divider(height: twentyFourPx),
          _buildInfoRow(context, 'Platform', 'Android & iOS'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDeveloperInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sixteenPx),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(twelvePx),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Developer',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: twelvePx),
          Text(
            'Sarah Tech',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: eightPx),
          Text(
            'We create useful and quality mobile applications for Bangladesh that make people\'s daily lives easier.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sixteenPx),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(twelvePx),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sixteenPx),

          // Email
          GestureDetector(
            onTap: _presenter.onContactEmailTap,
            child: Row(
              children: [
                Icon(Icons.email, color: Theme.of(context).primaryColor),
                SizedBox(width: twelvePx),
                Expanded(
                  child: Text(
                    reportEmailAddress,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: twelvePx),

          // Website
          GestureDetector(
            onTap: _presenter.onWebsiteTap,
            child: Row(
              children: [
                Icon(Icons.language, color: Theme.of(context).primaryColor),
                SizedBox(width: twelvePx),
                Expanded(
                  child: Text(
                    'royalcourtbd.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: sixteenPx),

          Text(
            'Contact us for any issues, suggestions or feedback.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

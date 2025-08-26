import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
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
            'সম্পর্কে',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: twelvePx),
          Text(
            'Dhaka Bus (ঢাকা বাস) হল ঢাকা শহরের বাস পরিবহন ব্যবস্থার জন্য একটি সম্পূর্ণ ডিজিটাল গাইড। এই অ্যাপটি যাত্রীদের সহজে বাস রুট খুঁজে পেতে এবং তাদের যাত্রার পরিকল্পনা করতে সাহায্য করে।',
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
        'title': 'সকল বাস রুট',
        'desc': 'ঢাকা শহরের সম্পূর্ণ বাস রুটের তথ্য',
      },
      {
        'icon': Icons.location_on,
        'title': 'বাস স্টপ',
        'desc': 'সকল বাস স্টপের সঠিক অবস্থান',
      },
      {
        'icon': Icons.search,
        'title': 'সহজ খোঁজা',
        'desc': 'দ্রুত এবং সহজ বাস রুট খোঁজার সুবিধা',
      },
      {
        'icon': Icons.directions,
        'title': 'যাত্রা পরিকল্পনা',
        'desc': 'গন্তব্য অনুযায়ী সেরা রুট সাজেশন',
      },
      {
        'icon': Icons.offline_pin,
        'title': 'অফলাইন সাপোর্ট',
        'desc': 'ইন্টারনেট ছাড়াই ব্যবহার করুন',
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
            'বৈশিষ্ট্যসমূহ',
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
            'ডেভেলপার',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: twelvePx),
          Text(
            'Royal Court BD',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: eightPx),
          Text(
            'আমরা বাংলাদেশের জন্য উপযোগী এবং মানসম্মত মোবাইল অ্যাপ্লিকেশন তৈরি করি যা মানুষের দৈনন্দিন জীবনকে সহজ করে তোলে।',
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
            'যোগাযোগ',
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
                    'report.irdfoundation@gmail.com',
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
            'যেকোনো সমস্যা, পরামর্শ বা মতামতের জন্য আমাদের সাথে যোগাযোগ করুন।',
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

import 'package:dhaka_bus/features/settings/presentation/widgets/appbar_ic_container.dart';
import 'package:dhaka_bus/features/settings/presentation/widgets/button_ctn.dart';
import 'package:dhaka_bus/features/settings/presentation/widgets/menu_item.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              AppbarIcContainer(assetPath: 'assets/svg/EN.svg'),
              Spacer(),
              Text('Menu', style: TextStyle(color: Colors.black, fontSize: 24)),
              Spacer(),
              AppbarIcContainer(assetPath: 'assets/svg/moon_icon.svg'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          MenuItem(
            itemAssetPath: 'assets/svg/notification.svg',
            itemTitle: 'Notification Settings',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/mail.svg',
            itemTitle: 'Email us for Queries.',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/facebook_icon.svg',
            itemTitle: 'Join our Facebook page',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/star.svg',
            itemTitle: 'Rate the app',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/feedback_icon.svg',
            itemTitle: 'Submit Feedback',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/share_icon.svg',
            itemTitle: 'Share the app',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/store.svg',
            itemTitle: 'Check out our other apps',
          ),

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 200),
            child: Text(
              'Our Services',
              style: TextStyle(
                color: Color(0xFFBC4377),
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/dev_icon.svg',
            itemTitle: 'App Design & Development',
          ),
          SizedBox(height: 10),
          MenuItem(
            itemAssetPath: 'assets/svg/web_icon.svg',
            itemTitle: 'Web Design & Development',
          ),
          SizedBox(height: 30),
          Center(child: VisitPortfolio()),
        ],
      ),
    );
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/external_libs/action_list_tile/action_list_tile.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Menu', isRoot: true, centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _buildListTile(
            //   context: context,
            //   title: 'Language / ভাষা',
            //   iconPath: SvgPath.icLanguage,
            //   onTap: () {},
            // ),
            _buildListTile(
              context: context,
              title: 'Notification',
              iconPath: SvgPath.icNotification,
              onTap: () {},
            ),

            _buildListTile(
              context: context,
              title: 'Contact Support',
              iconPath: SvgPath.icMail,
              onTap: () {},
            ),
            _buildListTile(
              context: context,
              title: 'Feedback',
              iconPath: SvgPath.icFeedback,
              onTap: () {},
            ),

            _buildListTile(
              context: context,
              title: 'Follow Us',
              iconPath: SvgPath.icFacebook,
              onTap: () {},
            ),

            _buildListTile(
              context: context,
              title: 'Share app',
              iconPath: SvgPath.icShare,
              onTap: () {},
            ),

            _buildListTile(
              context: context,
              title: 'Rate the app',
              iconPath: SvgPath.icStar,
              onTap: () {},
            ),

            _buildListTile(
              context: context,
              title: 'About Dhaka Bus',
              iconPath: SvgPath.icAbout,
              onTap: () {},
            ),
            _buildListTile(
              context: context,
              title: 'Privacy Policy',
              iconPath: SvgPath.icPrivacy,
              onTap: () {},
            ),

            _buildListTile(
              context: context,
              title: 'Other Apps',
              iconPath: SvgPath.icPlayStore,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  ActionListTile _buildListTile({
    required BuildContext context,
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return ActionListTile.svg(
      title: title,
      iconPath: iconPath,
      onTap: onTap,
      theme: ActionListTileTheme(
        iconSize: twentyFivePx,

        textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/external_libs/action_list_tile/action_list_tile.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/about/presentation/ui/about_page.dart';
import 'package:dhaka_bus/features/feedback/presentation/ui/feedback_page.dart';
import 'package:dhaka_bus/features/our_project/presentation/ui/our_project_page.dart';
import 'package:dhaka_bus/features/settings/presentation/presenter/settings_presenter.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsPresenter settingsPresenter = locate<SettingsPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: settingsPresenter,
      builder: () => Scaffold(
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
              // _buildListTile(
              //   context: context,
              //   title: 'Notification',
              //   iconPath: SvgPath.icNotification,
              //   onTap: () {},
              // ),
              // _buildListTile(
              //   context: context,
              //   title: 'Contact Support',
              //   iconPath: SvgPath.icMail,
              //   onTap: () => context.navigatorPush((ContactSupportPage())),
              // ),
              _buildListTile(
                context: context,
                title: 'Feedback',
                iconPath: SvgPath.icFeedback,
                onTap: () => context.navigatorPush(FeedbackPage()),
              ),

              _buildListTile(
                context: context,
                title: 'Follow Us',
                iconPath: SvgPath.icFacebook,
                onTap: () => settingsPresenter.addUserMessage('Coming Soon!'),
              ),

              _buildListTile(
                context: context,
                title: 'Share app',
                iconPath: SvgPath.icShare,
                onTap: settingsPresenter.onShareButtonClicked,
              ),

              _buildListTile(
                context: context,
                title: 'Rate the app',
                iconPath: SvgPath.icStar,
                onTap: settingsPresenter.onRatingClicked,
              ),

              _buildListTile(
                context: context,
                title: 'About Dhaka Bus',
                iconPath: SvgPath.icAbout,
                onTap: () => context.navigatorPush(AboutPage()),
              ),
              _buildListTile(
                context: context,
                title: 'Privacy Policy',
                iconPath: SvgPath.icPrivacy,
                onTap: settingsPresenter.onPrivacyPolicyClicked,
              ),

              _buildListTile(
                context: context,
                title: 'Other Apps',
                iconPath: SvgPath.icPlayStore,
                // onTap: () => settingsPresenter.onPlayStoreLinkClicked(context),
                onTap: () => context.navigatorPush(OurProjectPage()),
              ),

              Text(
                'App Version: ${settingsPresenter.currentUiState.appVersion ?? 'Loading...'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
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

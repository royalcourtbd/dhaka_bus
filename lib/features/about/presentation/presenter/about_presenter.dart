import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/services/email_service.dart';
import 'package:dhaka_bus/core/services/launcher_service.dart';
import 'package:dhaka_bus/core/static/build_info.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';
import 'package:dhaka_bus/features/about/presentation/presenter/about_ui_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPresenter extends BasePresenter<AboutUiState> {
  final Obs<AboutUiState> uiState = Obs<AboutUiState>(AboutUiState.empty());
  AboutUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await catchAndReturnFuture<PackageInfo>(() async {
      return await PackageInfo.fromPlatform();
    });

    // Get build time from compile time
    final buildTime = _getBuildDate();

    if (packageInfo != null) {
      uiState.value = currentUiState.copyWith(
        appVersion: '${packageInfo.version} (${packageInfo.buildNumber})',
        lastUpdated: buildTime,
      );
    } else {
      // Fallback version if package info fails
      uiState.value = currentUiState.copyWith(
        appVersion: '1.0.0',
        lastUpdated: buildTime,
      );
    }
  }

  String _getBuildDate() {
    // Use BuildInfo for consistent build date
    // This can be auto-updated during CI/CD process
    return BuildInfo.formattedBuildDate;
  }

  Future<void> onContactEmailTap() async {
    final bool? result = await catchAndReturnFuture<bool>(() async {
      await sendEmail(
        subject: 'Dhaka Bus App - Feedback',
        body: 'Write your feedback here...\n\n',
      );
      return true;
    });

    if (result == null) {
      await addUserMessage('Failed to open email app. Please try again.');
    }
  }

  Future<void> onWebsiteTap() async {
    const String websiteUrl = 'https://royalcourtbd.com';

    final bool? result = await catchAndReturnFuture<bool>(() async {
      await openUrl(url: websiteUrl);
      return true;
    });

    if (result == null) {
      await addUserMessage(
        'Failed to open website. Please visit in your browser: $websiteUrl',
      );
    }
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}

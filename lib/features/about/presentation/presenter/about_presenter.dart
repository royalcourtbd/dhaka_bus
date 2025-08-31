import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/services/launcher_service.dart';
import 'package:dhaka_bus/core/static/constants.dart';
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

    if (packageInfo != null) {
      uiState.value = currentUiState.copyWith(
        appVersion: '${packageInfo.version} (${packageInfo.buildNumber})',
      );
    } else {
      // Fallback version if package info fails
      uiState.value = currentUiState.copyWith(appVersion: '1.0.0');
    }
  }

  Future<void> onContactEmailTap() async {
    const email = reportEmailAddress;
    const subject = 'Dhaka Bus App - Feedback';
    const body = 'আপনার মতামত এখানে লিখুন...';

    final emailUrl =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    try {
      await openUrl(url: emailUrl);
    } catch (e) {
      await addUserMessage(
        'ইমেইল অ্যাপ খুলতে সমস্যা হয়েছে। অনুগ্রহ করে ম্যানুয়ালি ইমেইল করুন: $email',
      );
    }
  }

  Future<void> onWebsiteTap() async {
    const websiteUrl = 'https://royalcourtbd.com';

    try {
      await openUrl(url: websiteUrl);
    } catch (e) {
      await addUserMessage(
        'ওয়েবসাইট খুলতে সমস্যা হয়েছে। অনুগ্রহ করে ব্রাউজারে ভিজিট করুন: $websiteUrl',
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

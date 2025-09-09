import 'dart:io';

import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/core/services/connectivity_service.dart';
import 'package:dhaka_bus/core/services/launcher_service.dart';
import 'package:dhaka_bus/core/static/constants.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/core/utility/utility.dart';
import 'package:dhaka_bus/features/our_project/presentation/ui/our_project_page.dart';
import 'package:dhaka_bus/features/settings/domain/usecase/get_app_version_usecase.dart';
import 'package:dhaka_bus/features/settings/presentation/presenter/settings_ui_state.dart';

class SettingsPresenter extends BasePresenter<SettingsUiState> {
  final GetAppVersionUseCase _getAppVersionUseCase;

  SettingsPresenter(this._getAppVersionUseCase);

  final Obs<SettingsUiState> uiState = Obs<SettingsUiState>(
    SettingsUiState.empty(),
  );
  SettingsUiState get currentUiState => uiState.value;

  StreamSubscription<Either<String, String?>>? _appVersionSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    await handleStreamEvents<String?>(
      stream: _getAppVersionUseCase.execute(),
      subscription: _appVersionSubscription,
      onData: (version) {
        uiState.value = currentUiState.copyWith(
          appVersion: version ?? 'Version not available',
        );
      },
    );
  }

  @override
  void onClose() {
    _appVersionSubscription?.cancel();
    super.onClose();
  }

  Future<void> onPrivacyPolicyClicked() {
    return openUrl(url: privacyPolicyUrl);
  }

  Future<void> onRatingClicked() {
    return openUrl(url: suitableAppStoreUrl);
  }

  Future<void> onPlayStoreLinkClicked(BuildContext context) =>
      _onPromotionInteraction(
        onInternet: (url) => openUrl(url: url),
        onNoInternet: () => context.navigatorPush(OurProjectPage()),
      );

  Future<void> _onPromotionInteraction({
    required void Function(String promotionUrl) onInternet,
    required VoidCallback onNoInternet,
  }) async {
    final bool isNetworkAvailable = await checkInternetConnection();
    if (!isNetworkAvailable) {
      onNoInternet();
      return;
    }

    const String playStoreUrl =
        'https://play.google.com/store/apps/dev?id=8459316973763163049';

    const String appStoreUrl = 'https://apps.apple.com/us/developer/';

    final String promotionUrl = Platform.isAndroid ? playStoreUrl : appStoreUrl;

    onInternet(promotionUrl);
  }

  Future<void> onShareButtonClicked() async {
    final String shareableText =
        "Dhaka Bus (ঢাকা বাস) হল ঢাকা শহরের সম্পূর্ণ বাস রুট এবং তথ্যের জন্য "
        "একটি দুর্দান্ত অ্যাপ। এই অ্যাপে আপনি পাবেন:\n"
        "🚌 সকল বাস রুটের তথ্য\n"
        "📍 বাস স্টপের অবস্থান\n"
        "🔍 সহজ বাস খোঁজার সুবিধা\n\n"
        "অ্যাপটি ডাউনলোড করুন: $suitableAppStoreUrl";

    await shareText(text: shareableText);
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

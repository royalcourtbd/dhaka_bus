import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/core/services/launcher_service.dart';
import 'package:dhaka_bus/core/static/constants.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/core/utility/utility.dart';
import 'package:dhaka_bus/features/settings/presentation/presenter/settings_ui_state.dart';

class SettingsPresenter extends BasePresenter<SettingsUiState> {
  final Obs<SettingsUiState> uiState = Obs<SettingsUiState>(
    SettingsUiState.empty(),
  );
  SettingsUiState get currentUiState => uiState.value;

  Future<void> onPrivacyPolicyClicked() {
    return openUrl(url: privacyPolicyUrl);
  }

  Future<void> onRatingClicked() {
    return openUrl(url: suitableAppStoreUrl);
  }

  Future<void> onShareButtonClicked(BuildContext context) async {
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

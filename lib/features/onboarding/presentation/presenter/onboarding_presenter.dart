import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/onboarding/presentation/presenter/onboarding_ui_state.dart';

class OnboardingPresenter extends BasePresenter<OnboardingUiState> {
  final Obs<OnboardingUiState> uiState = Obs<OnboardingUiState>(
    OnboardingUiState.empty(),
  );
  OnboardingUiState get currentUiState => uiState.value;

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

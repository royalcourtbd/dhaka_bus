import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/our_project/presentation/presenter/our_project_ui_state.dart';

class OurProjectPresenter extends BasePresenter<OurProjectUiState> {
  final Obs<OurProjectUiState> uiState = Obs<OurProjectUiState>(OurProjectUiState.empty());
  OurProjectUiState get currentUiState => uiState.value;

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

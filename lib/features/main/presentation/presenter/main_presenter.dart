import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/core/services/time_service.dart';
import 'package:dhaka_bus/features/bus_list/presentation/presenter/bus_list_presenter.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:dhaka_bus/features/main/presentation/presenter/main_ui_state.dart';

class MainPresenter extends BasePresenter<MainUiState> {
  final Obs<MainUiState> uiState = Obs<MainUiState>(MainUiState.empty());
  MainUiState get currentUiState => uiState.value;

  final TimeService _timeService;

  MainPresenter(this._timeService);

  void changeNavigationIndex(int index) {
    // Clear and unfocus text fields when changing pages
    _clearAllPresentersOnPageChange();

    uiState.value = currentUiState.copyWith(selectedBottomNavIndex: index);
  }

  /// Clear and unfocus all presenter text fields when page changes
  void _clearAllPresentersOnPageChange() {
    try {
      // Clear BusPresenter (Bus Routes Display Page) - Page 0 & 2
      final busPresenter = locate<BusPresenter>();
      busPresenter.clearAndUnfocusOnPageChange();
    } catch (e) {
      // Presenter might not be initialized yet
    }

    try {
      // Clear BusListPresenter (Bus List Page) - Page 1
      final busListPresenter = locate<BusListPresenter>();
      busListPresenter.clearAndUnfocusOnPageChange();
    } catch (e) {
      // Presenter might not be initialized yet
    }
  }

  Future<void> handleBackPress() async {
    if (currentUiState.selectedBottomNavIndex != 0) {
      changeNavigationIndex(0);
      return;
    }

    final DateTime now = _timeService.currentTime;
    final DateTime lastPressed = currentUiState.lastBackPressTime ?? now;

    if (now.difference(lastPressed) > const Duration(seconds: 2)) {
      updateLastBackPressTime(now);
      addUserMessage('Press back again to exit');
      return;
    }

    await SystemNavigator.pop();
  }

  void updateLastBackPressTime(DateTime time) {
    uiState.value = currentUiState.copyWith(lastBackPressTime: time);
  }

  ///=======================================

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

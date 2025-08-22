import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/core/services/time_service.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';
import 'package:dhaka_bus/features/bus_list/bus_list_export.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/features/main/main_export.dart';

class MainPresenter extends BasePresenter<MainUiState> {
  final Obs<MainUiState> uiState = Obs<MainUiState>(MainUiState.empty());
  MainUiState get currentUiState => uiState.value;

  final TimeService _timeService;

  MainPresenter(this._timeService);

  void changeNavigationIndex(int index) {
    _clearAllPresentersOnPageChange();

    uiState.value = currentUiState.copyWith(selectedBottomNavIndex: index);
  }

  void _clearAllPresentersOnPageChange() {
    catchVoid(() {
      final busPresenter = locate<BusPresenter>();
      busPresenter.clearAndUnfocusOnPageChange();
    });

    catchVoid(() {
      final busListPresenter = locate<BusListPresenter>();
      busListPresenter.clearAndUnfocusOnPageChange();
    });
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

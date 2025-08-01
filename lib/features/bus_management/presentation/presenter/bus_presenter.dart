// lib/presentation/bus/presenter/bus_presenter.dart

import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_buses_use_case.dart';

import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_ui_state.dart';

class BusPresenter extends BasePresenter<BusUiState> {
  final GetBusesUseCase _getBusesUseCase;

  BusPresenter(this._getBusesUseCase);

  final Obs<BusUiState> uiState = Obs<BusUiState>(BusUiState.empty());
  BusUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();

    loadBuses();
  }

  /// Load all buses and print the data
  Future<void> loadBuses() async {
    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getBusesUseCase.execute(),
        onDataLoaded: (List<BusEntity> buses) {
          uiState.value = currentUiState.copyWith(allBuses: buses);
        },
      );
    });
  }

  /// Clear search results
  void clearSearch() {
    log('🚌 BusPresenter: Clearing search results');
    uiState.value = currentUiState.copyWith(searchResults: [], searchQuery: '');
  }

  /// Refresh all data
  Future<void> refreshAllData() async {
    log('🚌 BusPresenter: Refreshing all bus data...');
    await loadBuses();
    log('🚌 BusPresenter: All data refreshed successfully');
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: uiState.value.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  @override
  void onClose() {
    log('🚌 BusPresenter: Presenter is being disposed');
    super.onClose();
  }
}

// lib/presentation/bus/presenter/bus_presenter.dart

import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_buses_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_bus_by_id_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_buses_by_service_type_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/search_bus_use_case.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_ui_state.dart';

class BusPresenter extends BasePresenter<BusUiState> {
  final GetBusesUseCase _getBusesUseCase;
  final GetBusByIdUseCase _getBusByIdUseCase;
  final SearchBusUseCase _searchBusUseCase;
  final GetBusesByServiceTypeUseCase _getBusesByServiceTypeUseCase;

  BusPresenter(
    this._getBusesUseCase,
    this._getBusByIdUseCase,
    this._searchBusUseCase,
    this._getBusesByServiceTypeUseCase,
  );

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

  /// Load bus by ID and print the data
  Future<void> loadBusById(String busId) async {
    log('🚌 BusPresenter: Loading bus with ID: $busId');

    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<BusEntity?>(
        task: () => _getBusByIdUseCase.execute(busId),
        onDataLoaded: (BusEntity? bus) {
          if (bus != null) {
            log(
              '🚌 BusPresenter: Found bus - ${bus.busNameEn} (${bus.busNameBn})',
            );
            log(
              '🚌 Bus Details: Service Type: ${bus.serviceType}, Active: ${bus.isActive}, Created: ${bus.createdAt}',
            );

            // Update UI state
            uiState.value = currentUiState.copyWith(selectedBus: bus);
          } else {
            log('🚌 BusPresenter: No bus found with ID: $busId');
          }
        },
      );
    });
  }

  /// Search buses and print results
  Future<void> searchBuses(String searchQuery) async {
    log('🚌 BusPresenter: Searching buses with query: "$searchQuery"');

    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _searchBusUseCase.execute(searchQuery),
        onDataLoaded: (List<BusEntity> searchResults) {
          log(
            '🚌 BusPresenter: Search found ${searchResults.length} results for: "$searchQuery"',
          );

          // Print search results
          for (int i = 0; i < searchResults.length; i++) {
            final bus = searchResults[i];
            log(
              '🚌 Search Result ${i + 1}: ${bus.busNameEn} (${bus.busNameBn}) - Service: ${bus.serviceType ?? 'N/A'}',
            );
          }

          // Update UI state
          uiState.value = currentUiState.copyWith(
            searchResults: searchResults,
            searchQuery: searchQuery,
          );

          log('🚌 BusPresenter: Search results updated in UI state');
        },
      );
    });
  }

  /// Load buses by service type and print the data
  Future<void> loadBusesByServiceType(String serviceType) async {
    log('🚌 BusPresenter: Loading buses for service type: "$serviceType"');

    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getBusesByServiceTypeUseCase.execute(serviceType),
        onDataLoaded: (List<BusEntity> buses) {
          log(
            '🚌 BusPresenter: Found ${buses.length} buses for service type: "$serviceType"',
          );

          // Print buses by service type
          for (int i = 0; i < buses.length; i++) {
            final bus = buses[i];
            log(
              '🚌 $serviceType Bus ${i + 1}: ${bus.busNameEn} (${bus.busNameBn}) - Active: ${bus.isActive}',
            );
          }

          log('🚌 BusPresenter: Service type filtering completed');
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

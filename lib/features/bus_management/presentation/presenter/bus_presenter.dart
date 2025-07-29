// lib/presentation/bus/presenter/bus_presenter.dart

import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_active_buses_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_all_buses_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_bus_by_id_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_buses_by_service_type_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/search_bus_use_case.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_ui_state.dart';

class BusPresenter extends BasePresenter<BusUiState> {
  final GetAllBusesUseCase _getAllBusesUseCase;
  final GetBusByIdUseCase _getBusByIdUseCase;
  final SearchBusUseCase _searchBusUseCase;
  final GetActiveBusesUseCase _getActiveBusesUseCase;
  final GetBusesByServiceTypeUseCase _getBusesByServiceTypeUseCase;

  BusPresenter(
    this._getAllBusesUseCase,
    this._getBusByIdUseCase,
    this._searchBusUseCase,
    this._getActiveBusesUseCase,
    this._getBusesByServiceTypeUseCase,
  );

  final Obs<BusUiState> uiState = Obs<BusUiState>(BusUiState.empty());
  BusUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize করার সময় সব buses load করি
    loadAllBuses();
  }

  /// Load all buses and print the data
  Future<void> loadAllBuses() async {
    log('🚌 BusPresenter: Starting to load all buses...');

    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllBusesUseCase.execute(),
        onDataLoaded: (List<BusEntity> buses) {
          log('🚌 BusPresenter: Successfully loaded ${buses.length} buses');

          // Print each bus data
          for (int i = 0; i < buses.length; i++) {
            final bus = buses[i];
            log(
              '🚌 Bus ${i + 1}: ${bus.busNameEn} (${bus.busNameBn}) - Service: ${bus.serviceType ?? 'N/A'} - Active: ${bus.isActive}',
            );
          }

          // Update UI state
          uiState.value = currentUiState.copyWith(allBuses: buses);

          log('🚌 BusPresenter: All buses data updated in UI state');
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
            isSearchMode: true,
          );

          log('🚌 BusPresenter: Search results updated in UI state');
        },
      );
    });
  }

  /// Load active buses and print the data
  Future<void> loadActiveBuses() async {
    log('🚌 BusPresenter: Loading active buses only...');

    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getActiveBusesUseCase.execute(),
        onDataLoaded: (List<BusEntity> activeBuses) {
          log('🚌 BusPresenter: Found ${activeBuses.length} active buses');

          // Print active buses
          for (int i = 0; i < activeBuses.length; i++) {
            final bus = activeBuses[i];
            log(
              '🚌 Active Bus ${i + 1}: ${bus.busNameEn} (${bus.busNameBn}) - Service: ${bus.serviceType ?? 'N/A'}',
            );
          }

          // Update UI state
          uiState.value = currentUiState.copyWith(activeBuses: activeBuses);

          log('🚌 BusPresenter: Active buses data updated in UI state');
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
    uiState.value = currentUiState.copyWith(
      searchResults: [],
      searchQuery: '',
      isSearchMode: false,
    );
  }

  /// Refresh all data
  Future<void> refreshAllData() async {
    log('🚌 BusPresenter: Refreshing all bus data...');
    await loadAllBuses();
    await loadActiveBuses();
    log('🚌 BusPresenter: All data refreshed successfully');
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    log('🚌 BusPresenter: User message - $message');
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
    log('🚌 BusPresenter: Loading state - $loading');
  }

  @override
  void onClose() {
    log('🚌 BusPresenter: Presenter is being disposed');
    super.onClose();
  }
}

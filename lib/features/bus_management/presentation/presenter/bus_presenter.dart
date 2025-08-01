// lib/presentation/bus/presenter/bus_presenter.dart

import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/bus_management/data/services/data_sync_service.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_all_active_buses_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_routes_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_routes_by_bus_id_use_case.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_ui_state.dart';

class BusPresenter extends BasePresenter<BusUiState> {
  final GetBusesUseCase _getAllActiveBusesUseCase;
  final GetRoutesUseCase _getRoutesUseCase;
  final GetRoutesByBusIdUseCase _getRoutesByBusIdUseCase;
  final DataSyncService _dataSyncService;

  BusPresenter(
    this._getAllActiveBusesUseCase,
    this._getRoutesUseCase,
    this._getRoutesByBusIdUseCase,
    this._dataSyncService,
  );

  final Obs<BusUiState> uiState = Obs<BusUiState>(BusUiState.empty());
  BusUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    loadBusesAndRoutes(forceSync: true);
  }

  /// Load all buses and routes together (cache-first strategy)
  Future<void> loadBusesAndRoutes({bool forceSync = false}) async {
    log('🚌 BusPresenter: Loading buses and routes... (forceSync: $forceSync)');

    await executeTaskWithLoading(() async {
      // Load buses first (from cache, then sync if needed)
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<BusEntity> buses) {
          log('🚌 BusPresenter: Loaded ${buses.length} buses');
          uiState.value = currentUiState.copyWith(allBuses: buses);
        },
      );

      // Then load all routes (from cache, then sync if needed)
      await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
        task: () => _getRoutesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<RouteEntity> routes) {
          log('🛣️ BusPresenter: Loaded ${routes.length} routes');

          // Group routes by bus_id for quick lookup
          final Map<String, List<RouteEntity>> busRoutesMap = {};
          for (final route in routes) {
            if (!busRoutesMap.containsKey(route.busId)) {
              busRoutesMap[route.busId] = [];
            }
            busRoutesMap[route.busId]!.add(route);
          }

          log(
            '🛣️ BusPresenter: Grouped routes for ${busRoutesMap.keys.length} unique buses',
          );

          uiState.value = currentUiState.copyWith(
            allRoutes: routes,
            busRoutes: busRoutesMap,
          );
        },
      );
    });
  }

  /// Load all buses (cache-first strategy)
  Future<void> loadBuses({bool forceSync = false}) async {
    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<BusEntity> buses) {
          uiState.value = currentUiState.copyWith(allBuses: buses);
        },
      );
    });
  }

  /// Load routes for a specific bus
  Future<void> loadRoutesForBus(String busId) async {
    log('🛣️ BusPresenter: Loading routes for bus: $busId');

    await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
      task: () => _getRoutesByBusIdUseCase.execute(busId),
      onDataLoaded: (List<RouteEntity> routes) {
        log('🛣️ BusPresenter: Found ${routes.length} routes for bus: $busId');

        // Update the busRoutes map
        final updatedBusRoutes = Map<String, List<RouteEntity>>.from(
          currentUiState.busRoutes,
        );
        updatedBusRoutes[busId] = routes;

        uiState.value = currentUiState.copyWith(busRoutes: updatedBusRoutes);
      },
    );
  }

  /// Get routes for a specific bus from current state
  List<RouteEntity> getRoutesForBus(String busId) {
    return currentUiState.busRoutes[busId] ?? [];
  }

  /// Get route count for a specific bus
  int getRouteCountForBus(String busId) {
    return getRoutesForBus(busId).length;
  }

  /// Clear search results
  void clearSearch() {
    log('🚌 BusPresenter: Clearing search results');
    uiState.value = currentUiState.copyWith(searchResults: [], searchQuery: '');
  }

  /// Refresh all data (force sync from server)
  Future<void> refreshAllData() async {
    log('🚌 BusPresenter: Force refreshing all bus and route data...');
    await loadBusesAndRoutes(forceSync: true);
    log('🚌 BusPresenter: All data refreshed successfully');
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    log('🗑️ BusPresenter: Clearing all cached data...');
    await _dataSyncService.clearAllCache();
    // Reload data after clearing cache
    await loadBusesAndRoutes(forceSync: true);
    log('🗑️ BusPresenter: Cache cleared and data reloaded');
  }

  /// Get sync status information
  Future<Map<String, dynamic>> getSyncStatus() async {
    return await _dataSyncService.getSyncStatus();
  }

  /// Check if internet is available
  Future<bool> isInternetAvailable() async {
    return await _dataSyncService.isInternetAvailable();
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

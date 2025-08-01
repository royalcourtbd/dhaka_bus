// lib/presentation/bus/presenter/bus_presenter.dart

import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
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

  BusPresenter(
    this._getAllActiveBusesUseCase,
    this._getRoutesUseCase,
    this._getRoutesByBusIdUseCase,
  );

  final Obs<BusUiState> uiState = Obs<BusUiState>(BusUiState.empty());
  BusUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    loadBusesAndRoutes();
  }

  /// Load all buses and routes together
  Future<void> loadBusesAndRoutes() async {
    log('🚌 BusPresenter: Loading buses and routes...');

    await executeTaskWithLoading(() async {
      // Load buses first
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(),
        onDataLoaded: (List<BusEntity> buses) {
          log('🚌 BusPresenter: Loaded ${buses.length} buses');
          uiState.value = currentUiState.copyWith(allBuses: buses);
        },
      );

      // Then load all routes
      await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
        task: () => _getRoutesUseCase.execute(),
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

  /// Load all buses and print the data
  Future<void> loadBuses() async {
    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(),
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

  /// Refresh all data
  Future<void> refreshAllData() async {
    log('🚌 BusPresenter: Refreshing all bus and route data...');
    await loadBusesAndRoutes();
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

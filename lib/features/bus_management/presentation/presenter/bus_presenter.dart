// File: bus_management/presentation/presenter/bus_presenter.dart

// lib/presentation/bus/presenter/bus_presenter.dart

import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:flutter/widgets.dart';

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

  final TextEditingController startingStationNameController =
      TextEditingController();
  final TextEditingController destinationStationNameController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadBusesAndRoutes(
      forceSync: false,
    ); // Changed from true to false for normal cache-first behavior
  }

  /// Load all buses and routes together (cache-first strategy)
  Future<void> loadBusesAndRoutes({bool forceSync = false}) async {
    final syncType = forceSync ? 'FORCE SYNC' : 'CACHE-FIRST';
    log('🚌 BusPresenter: Loading buses and routes... (strategy: $syncType)');

    // Check if this is first time load
    final busSync = await _dataSyncService.getSyncStatus();
    final isFirstTime = busSync['needsSync'] == true;

    await executeTaskWithLoading(() async {
      // Update UI state to indicate first time load
      uiState.value = currentUiState.copyWith(
        isFirstTimeLoad: isFirstTime,
        lastDataSource: 'loading',
      );

      // Load buses first (from cache, then sync if needed)
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<BusEntity> buses) {
          log(
            '🚌 BusPresenter: ✅ Successfully loaded ${buses.length} buses in UI State',
          );

          // Sort the bus list alphabetically by name
          buses.sort((a, b) => a.busNameEn.compareTo(b.busNameEn));
          log('🚌 BusPresenter: Sorted bus list alphabetically.');

          // Determine data source based on DataSyncService behavior:
          // - forceSync=true: Always tries Firebase first
          // - forceSync=false + isFirstTime=true: Cache empty, goes to Firebase
          // - forceSync=false + isFirstTime=false: Uses cache (localStorage)
          String dataSource;
          if (forceSync) {
            dataSource = 'firebase';
          } else if (isFirstTime) {
            dataSource = 'firebase'; // First time always fetches from Firebase
          } else {
            dataSource = 'localStorage'; // Subsequent loads use cache
          }

          uiState.value = currentUiState.copyWith(
            allBuses: buses,
            lastDataSource: dataSource,
          );
        },
      );

      // Then load all routes (from cache, then sync if needed)
      await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
        task: () => _getRoutesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<RouteEntity> routes) {
          log(
            '🛣️ BusPresenter: ✅ Successfully loaded ${routes.length} routes in UI State',
          );

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

          //Create a unique stops list

          final Set<String> uniqueStopsSet = {};
          for (final route in routes) {
            uniqueStopsSet.addAll(route.stops);
          }

          final List<String> uniqueStopsList = uniqueStopsSet.toList()..sort();

          uiState.value = currentUiState.copyWith(
            allRoutes: routes,
            busRoutes: busRoutesMap,
            uniqueStops: uniqueStopsList,
          );

          log(
            '🎯 BusPresenter: ✅ DATA LOADING COMPLETE - UI State updated with all data',
          );
        },
      );
    });
  }

  /// Search for buses that travel between the selected origin and destination
  /// Supports bidirectional route search (both forward and reverse directions)
  void findBusesByRoute() {
    final String origin = startingStationNameController.text.trim();
    final String destination = destinationStationNameController.text.trim();

    if (origin.isEmpty || destination.isEmpty) {
      clearSearch();
      addUserMessage('Please select both origin and destination.');
      return;
    }

    final List<BusEntity> allBuses = currentUiState.allBuses;
    final Map<String, List<RouteEntity>> allBusRoutes =
        currentUiState.busRoutes;
    final List<BusEntity> filteredBuses = [];

    for (final bus in allBuses) {
      final List<RouteEntity>? routesForBus = allBusRoutes[bus.busId];
      if (routesForBus != null) {
        for (final route in routesForBus) {
          final int originIndex = route.stops.indexOf(origin);
          final int destinationIndex = route.stops.indexOf(destination);

          // Check if both stops exist in the route
          if (originIndex != -1 && destinationIndex != -1) {
            // Support bidirectional search:
            // Forward: origin comes before destination (originIndex < destinationIndex)
            // Reverse: origin comes after destination (originIndex > destinationIndex)
            final bool isForwardRoute = originIndex < destinationIndex;
            final bool isReverseRoute = originIndex > destinationIndex;

            if (isForwardRoute || isReverseRoute) {
              filteredBuses.add(bus);
              log(
                '🚌 Bus ${bus.busNameEn} matches route: ${isForwardRoute ? 'Forward' : 'Reverse'} direction',
              );
              break; // Bus found, move to the next bus
            }
          }
        }
      }
    }

    log('Found ${filteredBuses.length} buses for route $origin → $destination');
    uiState.value = currentUiState.copyWith(
      searchResults: filteredBuses,
      searchQuery: '$origin-$destination',
    );
  }

  /// Load all buses (cache-first strategy)
  Future<void> loadBuses({bool forceSync = false}) async {
    await executeTaskWithLoading(() async {
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<BusEntity> buses) {
          // Sort the bus list alphabetically by name
          buses.sort((a, b) => a.busNameEn.compareTo(b.busNameEn));
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
    // Reset search-related UI state
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

  /// Toggle expansion state for a specific card (only one card can be expanded at a time)
  void toggleCardExpansion(String cardId) {
    final String? currentExpandedCard = currentUiState.expandedCardId;

    if (currentExpandedCard == cardId) {
      // If clicking the same card, collapse it
      uiState.value = currentUiState.copyWith(clearExpandedCardId: true);
    } else {
      // If clicking a different card, expand it and collapse others
      uiState.value = currentUiState.copyWith(expandedCardId: cardId);
    }
  }

  /// Check if a specific card is expanded
  bool isCardExpanded(String cardId) {
    return currentUiState.expandedCardId == cardId;
  }

  void swapLocations() {
    final temp = startingStationNameController.text;
    startingStationNameController.text = destinationStationNameController.text;
    destinationStationNameController.text = temp;

    uiState.value = currentUiState.copyWith();
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
    startingStationNameController.dispose();
    destinationStationNameController.dispose();
    super.onClose();
  }
}

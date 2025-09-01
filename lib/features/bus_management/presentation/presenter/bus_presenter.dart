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

  /// Listen to starting station text changes
  void _onStartingStationChanged() {
    uiState.value = currentUiState.copyWith(
      startingStation: startingStationNameController.text,
    );
  }

  /// Listen to destination station text changes
  void _onDestinationStationChanged() {
    uiState.value = currentUiState.copyWith(
      destinationStation: destinationStationNameController.text,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Add listeners to sync TextEditingController with UI state
    startingStationNameController.addListener(_onStartingStationChanged);
    destinationStationNameController.addListener(_onDestinationStationChanged);
    // Load data from cache first (instant loading after splash)
    loadCachedDataOnly();
  }

  /// Load cached data only (instant loading after splash initialization)
  Future<void> loadCachedDataOnly() async {
    await executeTaskWithLoading(() async {
      // Load buses from cache only
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(forceSync: false),
        onDataLoaded: (List<BusEntity> buses) {
          // Sort the bus list alphabetically by name
          buses.sort((a, b) => a.busNameEn.compareTo(b.busNameEn));

          uiState.value = currentUiState.copyWith(
            allBuses: buses,
            lastDataSource: 'localStorage',
          );
        },
      );

      // Load routes from cache only
      await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
        task: () => _getRoutesUseCase.execute(forceSync: false),
        onDataLoaded: (List<RouteEntity> routes) {
          // Group routes by bus_id for quick lookup
          final Map<String, List<RouteEntity>> busRoutesMap = {};
          for (final route in routes) {
            if (!busRoutesMap.containsKey(route.busId)) {
              busRoutesMap[route.busId] = [];
            }
            busRoutesMap[route.busId]!.add(route);
          }

          // Create unique stops list
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
        },
      );
    });
  }

  /// Load all buses and routes together (used for manual refresh)
  Future<void> loadBusesAndRoutes({bool forceSync = false}) async {
    // Check if this is first time load
    final busSync = await _dataSyncService.getSyncStatus();
    final isFirstTime = busSync['needsSync'] == true;

    await executeTaskWithLoading(() async {
      // Update UI state to indicate refresh in progress
      uiState.value = currentUiState.copyWith(
        isFirstTimeLoad: isFirstTime,
        lastDataSource: forceSync ? 'firebase' : 'refreshing',
      );

      // Load buses (from cache or force from Firebase)
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getAllActiveBusesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<BusEntity> buses) {
          // Sort the bus list alphabetically by name
          buses.sort((a, b) => a.busNameEn.compareTo(b.busNameEn));

          // Determine data source
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

      // Then load all routes (from cache or force from Firebase)
      await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
        task: () => _getRoutesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<RouteEntity> routes) {
          // Group routes by bus_id for quick lookup
          final Map<String, List<RouteEntity>> busRoutesMap = {};
          for (final route in routes) {
            if (!busRoutesMap.containsKey(route.busId)) {
              busRoutesMap[route.busId] = [];
            }
            busRoutesMap[route.busId]!.add(route);
          }

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
        },
      );
    });
  }

  /// Search for buses that travel between the selected origin and destination
  /// Supports bidirectional route search (both forward and reverse directions)
  void findBusesByRoute() {
    final String origin = currentUiState.startingStation.trim();
    final String destination = currentUiState.destinationStation.trim();

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

              break; // Bus found, move to the next bus
            }
          }
        }
      }
    }

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
    await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
      task: () => _getRoutesByBusIdUseCase.execute(busId),
      onDataLoaded: (List<RouteEntity> routes) {
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

  /// Optional: Background refresh without loading indicator
  Future<void> backgroundRefresh() async {
    // Refresh data in background without showing loading to user
    try {
      final buses = await _getAllActiveBusesUseCase.execute(forceSync: false);
      final routes = await _getRoutesUseCase.execute(forceSync: false);

      buses.fold((error) => log('⚠️ Background bus refresh failed: $error'), (
        busData,
      ) {
        busData.sort((a, b) => a.busNameEn.compareTo(b.busNameEn));

        routes.fold(
          (error) => log('⚠️ Background route refresh failed: $error'),
          (routeData) {
            // Update UI state silently
            final Map<String, List<RouteEntity>> busRoutesMap = {};
            for (final route in routeData) {
              if (!busRoutesMap.containsKey(route.busId)) {
                busRoutesMap[route.busId] = [];
              }
              busRoutesMap[route.busId]!.add(route);
            }

            final Set<String> uniqueStopsSet = {};
            for (final route in routeData) {
              uniqueStopsSet.addAll(route.stops);
            }
            final List<String> uniqueStopsList = uniqueStopsSet.toList()
              ..sort();

            uiState.value = currentUiState.copyWith(
              allBuses: busData,
              allRoutes: routeData,
              busRoutes: busRoutesMap,
              uniqueStops: uniqueStopsList,
              lastDataSource: 'background_refresh',
            );
          },
        );
      });
    } catch (e) {
      log('⚠️ Background refresh error: $e');
    }
  }

  /// Clear search results
  void clearSearch() {
    // Reset search-related UI state
    uiState.value = currentUiState.copyWith(searchResults: [], searchQuery: '');
  }

  /// Refresh all data (force sync from server)
  Future<void> refreshAllData() async {
    await loadBusesAndRoutes(forceSync: true);
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    await _dataSyncService.clearAllCache();
    // Reload data after clearing cache
    await loadBusesAndRoutes(forceSync: true);
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

    // Update UI state to trigger reactive rebuilds
    uiState.value = currentUiState.copyWith(
      startingStation: startingStationNameController.text,
      destinationStation: destinationStationNameController.text,
    );
  }

  /// Clear text fields and unfocus when page changes
  void clearAndUnfocusOnPageChange() {
    startingStationNameController.clear();
    destinationStationNameController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    // Update UI state to reflect cleared text fields
    uiState.value = currentUiState.copyWith(
      startingStation: '',
      destinationStation: '',
    );

    clearSearch();
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
    // Remove listeners before disposing controllers
    startingStationNameController.removeListener(_onStartingStationChanged);
    destinationStationNameController.removeListener(
      _onDestinationStationChanged,
    );

    startingStationNameController.dispose();
    destinationStationNameController.dispose();
    super.onClose();
  }
}

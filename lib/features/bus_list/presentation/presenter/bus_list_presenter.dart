import 'dart:async';
import 'dart:developer';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/bus_list/presentation/presenter/bus_list_ui_state.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';

class RouteData {
  final String description;
  final String fullRoute;

  const RouteData({required this.description, required this.fullRoute});
}

class BusListPresenter extends BasePresenter<BusListUiState> {
  final GetBusesUseCase _getBusesUseCase;
  final GetRoutesUseCase _getRoutesUseCase;

  BusListPresenter(this._getBusesUseCase, this._getRoutesUseCase);

  final Obs<BusListUiState> uiState = Obs<BusListUiState>(
    BusListUiState.empty(),
  );
  BusListUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    loadBusesWithRoutes();
  }

  // ==================== UI STATE CHECKS ====================

  bool shouldShowLoading() {
    return currentUiState.isLoading && currentUiState.filteredBuses.isEmpty;
  }

  bool shouldShowNoSearchResults() {
    return currentUiState.filteredBuses.isEmpty &&
        currentUiState.searchQuery.isNotEmpty;
  }

  bool shouldShowEmptyState() {
    return currentUiState.filteredBuses.isEmpty &&
        !currentUiState.isLoading &&
        currentUiState.searchQuery.isEmpty;
  }

  // ==================== DATA ACCESS METHODS ====================

  int getDisplayBusesCount() {
    return currentUiState.filteredBuses.length;
  }

  BusEntity getBusAt(int index) {
    return currentUiState.filteredBuses[index];
  }

  String getCardId(String busId, int index) {
    return 'bus_list_${busId}_$index';
  }

  RouteData getRouteDataForBus(String busId) {
    final routes = getRoutesForBus(busId);

    if (routes.isEmpty) {
      return const RouteData(
        description: 'Route Information Not Available',
        fullRoute: 'Route Information Not Available',
      );
    }

    final firstRoute = routes.first;
    final stops = firstRoute.stops;

    if (stops.isEmpty) {
      return const RouteData(
        description: 'Route Information Not Available',
        fullRoute: 'Route Information Not Available',
      );
    }

    if (stops.length == 1) {
      return RouteData(description: stops.first, fullRoute: stops.first);
    }

    return RouteData(
      description: '${stops.first} → ${stops.last}',
      fullRoute: stops.join(' → '),
    );
  }

  // ==================== BUSINESS LOGIC ====================

  Future<void> loadBusesWithRoutes({bool forceSync = false}) async {
    log('🚌 BusListPresenter: Loading buses with routes...');

    await executeTaskWithLoading(() async {
      // Load buses first
      await parseDataFromEitherWithUserMessage<List<BusEntity>>(
        task: () => _getBusesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<BusEntity> buses) {
          log('🚌 BusListPresenter: Loaded ${buses.length} buses');
          buses.sort((a, b) => a.busNameEn.compareTo(b.busNameEn));

          uiState.value = currentUiState.copyWith(
            allBuses: buses,
            filteredBuses: buses,
          );
        },
      );

      // Then load routes
      await parseDataFromEitherWithUserMessage<List<RouteEntity>>(
        task: () => _getRoutesUseCase.execute(forceSync: forceSync),
        onDataLoaded: (List<RouteEntity> routes) {
          log('🛣️ BusListPresenter: Loaded ${routes.length} routes');

          final Map<String, List<RouteEntity>> busRoutesMap = {};
          for (final route in routes) {
            if (!busRoutesMap.containsKey(route.busId)) {
              busRoutesMap[route.busId] = [];
            }
            busRoutesMap[route.busId]!.add(route);
          }

          uiState.value = currentUiState.copyWith(
            allRoutes: routes,
            busRoutes: busRoutesMap,
          );

          log('🎯 BusListPresenter: Data loading complete');
        },
      );
    });
  }

  void searchBuses(String query) {
    log('🔍 BusListPresenter: Searching buses with query: "$query"');

    if (query.trim().isEmpty) {
      uiState.value = currentUiState.copyWith(
        filteredBuses: currentUiState.allBuses,
        searchQuery: '',
      );
      return;
    }

    final String lowercaseQuery = query.toLowerCase();
    final List<BusEntity> filtered = currentUiState.allBuses.where((bus) {
      return bus.busNameEn.toLowerCase().contains(lowercaseQuery) ||
          bus.busNameBn.toLowerCase().contains(lowercaseQuery);
    }).toList();

    log('🔍 Found ${filtered.length} buses matching "$query"');

    uiState.value = currentUiState.copyWith(
      filteredBuses: filtered,
      searchQuery: query,
    );
  }

  void clearSearch() {
    log('🚌 BusListPresenter: Clearing search');
    uiState.value = currentUiState.copyWith(
      filteredBuses: currentUiState.allBuses,
      searchQuery: '',
    );
  }

  List<RouteEntity> getRoutesForBus(String busId) {
    return currentUiState.busRoutes[busId] ?? [];
  }

  void toggleCardExpansion(String cardId) {
    final String? currentExpandedCard = currentUiState.expandedCardId;

    if (currentExpandedCard == cardId) {
      uiState.value = currentUiState.copyWith(clearExpandedCardId: true);
    } else {
      uiState.value = currentUiState.copyWith(expandedCardId: cardId);
    }
  }

  bool isCardExpanded(String cardId) {
    return currentUiState.expandedCardId == cardId;
  }

  Future<void> refreshData() async {
    log('🚌 BusListPresenter: Refreshing data...');
    await loadBusesWithRoutes(forceSync: true);
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

  @override
  void onClose() {
    log('🚌 BusListPresenter: Presenter disposed');
    super.onClose();
  }
}

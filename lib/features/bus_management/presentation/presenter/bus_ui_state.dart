// lib/presentation/bus/presenter/bus_ui_state.dart

import 'package:dhaka_bus/core/base/base_ui_state.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';

class BusUiState extends BaseUiState {
  const BusUiState({
    required super.isLoading,
    required super.userMessage,
    required this.allBuses,
    required this.selectedBus,
    required this.searchResults,
    required this.searchQuery,
    required this.allRoutes,
    required this.busRoutes,
    required this.expandedCardId,
    required this.uniqueStops,
    required this.startingStation,
    required this.destinationStation,
    this.lastDataSource,
    this.isFirstTimeLoad = false,
  });

  factory BusUiState.empty() {
    return const BusUiState(
      isLoading: false,
      userMessage: '',
      allBuses: [],
      selectedBus: null,
      searchResults: [],
      searchQuery: '',
      allRoutes: [],
      busRoutes: {},
      expandedCardId: null,
      uniqueStops: [],
      startingStation: '',
      destinationStation: '',
      lastDataSource: null,
      isFirstTimeLoad: false,
    );
  }

  final List<BusEntity> allBuses;
  final BusEntity? selectedBus;
  final List<BusEntity> searchResults;
  final String searchQuery;
  final List<RouteEntity> allRoutes;
  final Map<String, List<RouteEntity>> busRoutes;
  final String? expandedCardId;
  final List<String> uniqueStops;
  final String startingStation;
  final String destinationStation;
  final String? lastDataSource;
  final bool isFirstTimeLoad;

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    allBuses,
    selectedBus,
    searchResults,
    searchQuery,
    allRoutes,
    busRoutes,
    expandedCardId,
    uniqueStops,
    startingStation,
    destinationStation,
    lastDataSource,
    isFirstTimeLoad,
  ];
  BusUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<BusEntity>? allBuses,
    BusEntity? selectedBus,
    List<BusEntity>? searchResults,
    String? searchQuery,
    List<RouteEntity>? allRoutes,
    Map<String, List<RouteEntity>>? busRoutes,
    String? expandedCardId,
    bool clearExpandedCardId = false,
    List<String>? uniqueStops,
    String? startingStation,
    String? destinationStation,
    String? lastDataSource,
    bool? isFirstTimeLoad,
  }) {
    return BusUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      allBuses: allBuses ?? this.allBuses,
      selectedBus: selectedBus ?? this.selectedBus,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      allRoutes: allRoutes ?? this.allRoutes,
      busRoutes: busRoutes ?? this.busRoutes,
      expandedCardId: clearExpandedCardId
          ? null
          : (expandedCardId ?? this.expandedCardId),
      uniqueStops: uniqueStops ?? this.uniqueStops,
      startingStation: startingStation ?? this.startingStation,
      destinationStation: destinationStation ?? this.destinationStation,
      lastDataSource: lastDataSource ?? this.lastDataSource,
      isFirstTimeLoad: isFirstTimeLoad ?? this.isFirstTimeLoad,
    );
  }
}

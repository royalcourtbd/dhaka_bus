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
    required this.busRoutes, // Routes for selected bus
    required this.expandedCardId, // Track which card is currently expanded
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
    );
  }

  final List<BusEntity> allBuses;
  final BusEntity? selectedBus;
  final List<BusEntity> searchResults;
  final String searchQuery;
  final List<RouteEntity> allRoutes;
  final Map<String, List<RouteEntity>> busRoutes; // bus_id -> routes mapping
  final String?
  expandedCardId; // Track which card is currently expanded (null means none)

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
    bool clearExpandedCardId =
        false, // Flag to explicitly set expandedCardId to null
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
    );
  }
}

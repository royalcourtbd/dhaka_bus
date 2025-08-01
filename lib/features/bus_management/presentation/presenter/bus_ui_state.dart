// lib/presentation/bus/presenter/bus_ui_state.dart

import 'package:dhaka_bus/core/base/base_ui_state.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';

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
    );
  }

  final List<BusEntity> allBuses;
  final BusEntity? selectedBus;
  final List<BusEntity> searchResults;
  final String searchQuery;
  final List<RouteEntity> allRoutes;
  final Map<String, List<RouteEntity>> busRoutes; // bus_id -> routes mapping

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
    );
  }
}

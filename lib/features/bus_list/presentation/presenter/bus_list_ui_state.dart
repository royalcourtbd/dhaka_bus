import 'package:dhaka_bus/core/base/base_ui_state.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';

class BusListUiState extends BaseUiState {
  const BusListUiState({
    required super.isLoading,
    required super.userMessage,
    required this.allBuses,
    required this.filteredBuses,
    required this.searchQuery,
    required this.allRoutes,
    required this.busRoutes,
    required this.expandedCardId,
  });

  factory BusListUiState.empty() {
    return const BusListUiState(
      isLoading: false,
      userMessage: '',
      allBuses: [],
      filteredBuses: [],
      searchQuery: '',
      allRoutes: [],
      busRoutes: {},
      expandedCardId: null,
    );
  }

  final List<BusEntity> allBuses;
  final List<BusEntity> filteredBuses;
  final String searchQuery;
  final List<RouteEntity> allRoutes;
  final Map<String, List<RouteEntity>> busRoutes;
  final String? expandedCardId;

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    allBuses,
    filteredBuses,
    searchQuery,
    allRoutes,
    busRoutes,
    expandedCardId,
  ];

  BusListUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<BusEntity>? allBuses,
    List<BusEntity>? filteredBuses,
    String? searchQuery,
    List<RouteEntity>? allRoutes,
    Map<String, List<RouteEntity>>? busRoutes,
    String? expandedCardId,
    bool clearExpandedCardId = false,
  }) {
    return BusListUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      allBuses: allBuses ?? this.allBuses,
      filteredBuses: filteredBuses ?? this.filteredBuses,
      searchQuery: searchQuery ?? this.searchQuery,
      allRoutes: allRoutes ?? this.allRoutes,
      busRoutes: busRoutes ?? this.busRoutes,
      expandedCardId: clearExpandedCardId
          ? null
          : (expandedCardId ?? this.expandedCardId),
    );
  }
}

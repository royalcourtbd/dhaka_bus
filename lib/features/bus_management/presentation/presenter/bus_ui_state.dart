// lib/presentation/bus/presenter/bus_ui_state.dart

import 'package:dhaka_bus/core/base/base_ui_state.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';

class BusUiState extends BaseUiState {
  const BusUiState({
    required super.isLoading,
    required super.userMessage,
    required this.allBuses,
    required this.selectedBus,
    required this.searchResults,
    required this.activeBuses,
    required this.searchQuery,
    required this.isSearchMode,
  });

  factory BusUiState.empty() {
    return const BusUiState(
      isLoading: false,
      userMessage: '',
      allBuses: [],
      selectedBus: null,
      searchResults: [],
      activeBuses: [],
      searchQuery: '',
      isSearchMode: false,
    );
  }

  final List<BusEntity> allBuses;
  final BusEntity? selectedBus;
  final List<BusEntity> searchResults;
  final List<BusEntity> activeBuses;
  final String searchQuery;
  final bool isSearchMode;

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    allBuses,
    selectedBus,
    searchResults,
    activeBuses,
    searchQuery,
    isSearchMode,
  ];

  BusUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<BusEntity>? allBuses,
    BusEntity? selectedBus,
    List<BusEntity>? searchResults,
    List<BusEntity>? activeBuses,
    String? searchQuery,
    bool? isSearchMode,
  }) {
    return BusUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      allBuses: allBuses ?? this.allBuses,
      selectedBus: selectedBus ?? this.selectedBus,
      searchResults: searchResults ?? this.searchResults,
      activeBuses: activeBuses ?? this.activeBuses,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchMode: isSearchMode ?? this.isSearchMode,
    );
  }
}

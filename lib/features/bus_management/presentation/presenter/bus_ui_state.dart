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

    required this.searchQuery,
  });

  factory BusUiState.empty() {
    return const BusUiState(
      isLoading: false,
      userMessage: '',
      allBuses: [],
      selectedBus: null,
      searchResults: [],

      searchQuery: '',
    );
  }

  final List<BusEntity> allBuses;
  final BusEntity? selectedBus;
  final List<BusEntity> searchResults;
  final String searchQuery;

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    allBuses,
    selectedBus,
    searchResults,
    searchQuery,
  ];

  BusUiState copyWith({
    bool? isLoading,
    String? userMessage,
    List<BusEntity>? allBuses,
    BusEntity? selectedBus,
    List<BusEntity>? searchResults,
    String? searchQuery,
  }) {
    return BusUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      allBuses: allBuses ?? this.allBuses,
      selectedBus: selectedBus ?? this.selectedBus,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

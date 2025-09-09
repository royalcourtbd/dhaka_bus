import 'package:dhaka_bus/core/base/base_ui_state.dart';

class OurProjectUiState extends BaseUiState {
  const OurProjectUiState({required super.isLoading, required super.userMessage});

  factory OurProjectUiState.empty() {
    return OurProjectUiState(isLoading: false, userMessage: '');
  }

  @override
  List<Object?> get props => [isLoading, userMessage];

  //Add more properties to the state

  OurProjectUiState copyWith({bool? isLoading, String? userMessage}) {
    return OurProjectUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}

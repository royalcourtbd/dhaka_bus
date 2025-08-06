import 'package:dhaka_bus/core/base/base_ui_state.dart';

class SettingsUiState extends BaseUiState {
  const SettingsUiState({required super.isLoading, required super.userMessage});

  factory SettingsUiState.empty() {
    return SettingsUiState(isLoading: false, userMessage: '');
  }

  @override
  List<Object?> get props => [isLoading, userMessage];

  //Add more properties to the state

  SettingsUiState copyWith({bool? isLoading, String? userMessage}) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
    );
  }
}

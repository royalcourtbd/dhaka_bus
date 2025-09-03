import 'package:dhaka_bus/core/base/base_ui_state.dart';

class SettingsUiState extends BaseUiState {
  final String? appVersion;

  const SettingsUiState({
    required super.isLoading,
    required super.userMessage,
    this.appVersion,
  });

  factory SettingsUiState.empty() {
    return SettingsUiState(isLoading: false, userMessage: '', appVersion: null);
  }

  @override
  List<Object?> get props => [isLoading, userMessage, appVersion];

  SettingsUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? appVersion,
  }) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

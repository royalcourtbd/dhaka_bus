import 'package:dhaka_bus/core/base/base_ui_state.dart';

class AboutUiState extends BaseUiState {
  final String appVersion;
  final String lastUpdated;

  const AboutUiState({
    required super.isLoading,
    required super.userMessage,
    required this.appVersion,
    required this.lastUpdated,
  });

  factory AboutUiState.empty() {
    return AboutUiState(
      isLoading: false,
      userMessage: '',
      appVersion: '1.0.0',
      lastUpdated: 'Loading...',
    );
  }

  @override
  List<Object?> get props => [isLoading, userMessage, appVersion, lastUpdated];

  AboutUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? appVersion,
    String? lastUpdated,
  }) {
    return AboutUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      appVersion: appVersion ?? this.appVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

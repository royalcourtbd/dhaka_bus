import 'package:dhaka_bus/core/base/base_ui_state.dart';

class AboutUiState extends BaseUiState {
  final String appVersion;

  const AboutUiState({
    required super.isLoading,
    required super.userMessage,
    required this.appVersion,
  });

  factory AboutUiState.empty() {
    return AboutUiState(isLoading: false, userMessage: '', appVersion: '1.0.0');
  }

  @override
  List<Object?> get props => [isLoading, userMessage, appVersion];

  AboutUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? appVersion,
  }) {
    return AboutUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

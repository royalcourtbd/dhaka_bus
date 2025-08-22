import 'package:dhaka_bus/core/base/base_ui_state.dart';

class SplashUiState extends BaseUiState {
  const SplashUiState({
    required super.isLoading,
    required super.userMessage,
    required this.isInitializationComplete,
    required this.shouldNavigateToMain,
  });

  final bool isInitializationComplete;
  final bool shouldNavigateToMain;

  factory SplashUiState.empty() {
    return SplashUiState(
      isLoading: false,
      userMessage: '',
      isInitializationComplete: false,
      shouldNavigateToMain: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isInitializationComplete,
    shouldNavigateToMain,
  ];

  SplashUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isInitializationComplete,
    bool? shouldNavigateToMain,
  }) {
    return SplashUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isInitializationComplete:
          isInitializationComplete ?? this.isInitializationComplete,
      shouldNavigateToMain: shouldNavigateToMain ?? this.shouldNavigateToMain,
    );
  }
}

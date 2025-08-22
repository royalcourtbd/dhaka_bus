import 'package:dhaka_bus/core/base/base_ui_state.dart';

class SplashUiState extends BaseUiState {
  const SplashUiState({
    required super.isLoading,
    required super.userMessage,
    required this.isInitializationComplete,
    required this.shouldNavigateToMain,
    required this.elapsedSeconds,
    required this.minimumTimeCompleted,
  });

  final bool isInitializationComplete;
  final bool shouldNavigateToMain;
  final int elapsedSeconds;
  final bool minimumTimeCompleted;

  factory SplashUiState.empty() {
    return SplashUiState(
      isLoading: false,
      userMessage: '',
      isInitializationComplete: false,
      shouldNavigateToMain: false,
      elapsedSeconds: 0,
      minimumTimeCompleted: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    isInitializationComplete,
    shouldNavigateToMain,
    elapsedSeconds,
    minimumTimeCompleted,
  ];

  SplashUiState copyWith({
    bool? isLoading,
    String? userMessage,
    bool? isInitializationComplete,
    bool? shouldNavigateToMain,
    int? elapsedSeconds,
    bool? minimumTimeCompleted,
  }) {
    return SplashUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      isInitializationComplete:
          isInitializationComplete ?? this.isInitializationComplete,
      shouldNavigateToMain: shouldNavigateToMain ?? this.shouldNavigateToMain,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      minimumTimeCompleted: minimumTimeCompleted ?? this.minimumTimeCompleted,
    );
  }
}

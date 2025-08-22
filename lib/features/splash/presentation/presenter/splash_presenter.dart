import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/splash/presentation/presenter/splash_ui_state.dart';
import 'package:dhaka_bus/features/splash/domain/usecase/initialize_app_use_case.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';
import 'package:dhaka_bus/core/services/time_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashPresenter extends BasePresenter<SplashUiState> {
  SplashPresenter(this._initializeAppUseCase, this._timeService);

  final InitializeAppUseCase _initializeAppUseCase;
  final TimeService _timeService;
  final Obs<SplashUiState> uiState = Obs<SplashUiState>(SplashUiState.empty());
  SplashUiState get currentUiState => uiState.value;

  DateTime? _splashStartTime;
  StreamSubscription<DateTime>? _timeSubscription;

  /// Initialize the splash screen flow
  Future<void> initializeSplash() async {
    logInfo('🎬 SplashPresenter: Starting splash screen flow...');

    // Record splash start time
    _splashStartTime = _timeService.getCurrentTime();

    // Start monitoring time for minimum duration
    _startTimeMonitoring();

    // Start app initialization
    await _performAppInitialization();
  }

  /// Start monitoring time using TimeService
  void _startTimeMonitoring() {
    logInfo(
      '⏱️ Starting time monitoring for minimum splash duration (3 seconds)...',
    );

    _timeSubscription = _timeService.currentTimeStream.listen((currentTime) {
      if (_splashStartTime != null) {
        final elapsedSeconds = currentTime
            .difference(_splashStartTime!)
            .inSeconds;
        final minimumTimeCompleted = elapsedSeconds >= 3;

        // Update UI state with elapsed time and completion status
        uiState.value = currentUiState.copyWith(
          elapsedSeconds: elapsedSeconds,
          minimumTimeCompleted: minimumTimeCompleted,
        );

        // Check if minimum time has passed and we're ready to navigate
        if (minimumTimeCompleted) {
          logInfo('⏱️ Minimum splash display time (3 seconds) completed');
          _checkIfReadyToNavigate();
        }
      }
    });
  }

  /// Perform app initialization
  Future<void> _performAppInitialization() async {
    logInfo('🔄 Starting app initialization process...');

    await parseDataFromEitherWithUserMessage<bool>(
      task: () => _initializeAppUseCase.execute(),
      onDataLoaded: (bool success) {
        if (success) {
          logInfo('✅ App initialization completed successfully');
          _markInitializationComplete();
          _checkIfReadyToNavigate();
        }
      },
    );
  }

  /// Mark initialization as complete in UI state
  void _markInitializationComplete() {
    uiState.value = currentUiState.copyWith(isInitializationComplete: true);
  }

  /// Check if both minimum time and initialization are complete
  void _checkIfReadyToNavigate() {
    final bool minimumTimeCompleted = currentUiState.minimumTimeCompleted;
    final bool initializationCompleted =
        currentUiState.isInitializationComplete;

    logInfo('🎯 Checking navigation readiness:');
    logInfo('   - Minimum time completed: $minimumTimeCompleted');
    logInfo('   - Initialization completed: $initializationCompleted');

    if (minimumTimeCompleted && initializationCompleted) {
      logInfo('🚀 Ready to navigate to main screen');
      _navigateToMainScreen();
    }
  }

  /// Navigate to the main screen
  void _navigateToMainScreen() {
    // Guard against multiple navigation calls using UI state
    if (currentUiState.hasNavigated) {
      logInfo('🚫 Navigation already triggered, skipping duplicate call');
      return;
    }

    // Remove native splash screen before navigation
    FlutterNativeSplash.remove();
    logInfo('🚀 Native splash screen removed');

    uiState.value = currentUiState.copyWith(shouldNavigateToMain: true);
    logInfo('📱 Triggering navigation to main screen');
  }

  /// Mark as navigated to prevent duplicate navigation calls
  void markAsNavigated() {
    uiState.value = currentUiState.copyWith(hasNavigated: true);
  }

  @override
  void onClose() {
    _timeSubscription?.cancel();
    super.onClose();
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}

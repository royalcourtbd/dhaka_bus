import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/features/splash/splash_export.dart';
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

  /// Initialize the splash screen flow, also used for retrying.
  Future<void> initializeSplash() async {
    // Reset state for initialization or retry
    uiState.value = SplashUiState.empty().copyWith(isLoading: true);

    // Record splash start time
    _splashStartTime = _timeService.getCurrentTime();

    // Cancel any existing timer before starting a new one
    _timeSubscription?.cancel();
    _startTimeMonitoring();

    // Start app initialization
    await _performAppInitialization();
  }

  /// Start monitoring time using TimeService
  void _startTimeMonitoring() {
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
          _checkIfReadyToNavigate();
        }
      }
    });
  }

  /// Perform app initialization
  Future<void> _performAppInitialization() async {
    await parseDataFromEitherWithUserMessage<bool>(
      task: () => _initializeAppUseCase.execute(),
      onDataLoaded: (bool success) {
        if (success) {
          _markInitializationComplete();
          // We don't need to call toggleLoading(false) here because it's handled by _checkIfReadyToNavigate logic implicitly
          _checkIfReadyToNavigate();
        }
      },
    );
  }

  /// Mark initialization as complete in UI state
  void _markInitializationComplete() {
    uiState.value = currentUiState.copyWith(
      isInitializationComplete: true,
      isLoading: false, // Stop loading on success
    );
  }

  /// Check if both minimum time and initialization are complete
  void _checkIfReadyToNavigate() {
    // Do not navigate if there is an error message.
    if (currentUiState.userMessage?.isNotEmpty == true) {
      logInfo('🚫 Navigation blocked due to an error message.');
      return;
    }

    final bool minimumTimeCompleted = currentUiState.minimumTimeCompleted;
    final bool initializationCompleted =
        currentUiState.isInitializationComplete;

    if (minimumTimeCompleted && initializationCompleted) {
      _navigateToMainScreen();
    }
  }

  /// Navigate to the main screen
  void _navigateToMainScreen() {
    // Guard against multiple navigation calls using UI state
    if (currentUiState.hasNavigated) {
      return;
    }

    // Remove native splash screen before navigation
    FlutterNativeSplash.remove();
    logInfo('🚀 Native splash screen removed');

    uiState.value = currentUiState.copyWith(shouldNavigateToMain: true);
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
    // When an error occurs, stop loading and show the message.
    uiState.value = currentUiState.copyWith(
      userMessage: message,
      isLoading: false,
    );
    // The base presenter might show a toast/snackbar, which is fine.
    // showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}

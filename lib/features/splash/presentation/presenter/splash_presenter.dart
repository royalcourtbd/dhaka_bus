import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/splash/presentation/presenter/splash_ui_state.dart';
import 'package:dhaka_bus/features/splash/domain/usecase/initialize_app_use_case.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';

class SplashPresenter extends BasePresenter<SplashUiState> {
  SplashPresenter(this._initializeAppUseCase);

  final InitializeAppUseCase _initializeAppUseCase;
  final Obs<SplashUiState> uiState = Obs<SplashUiState>(SplashUiState.empty());
  SplashUiState get currentUiState => uiState.value;

  Timer? _minimumDisplayTimer;
  bool _initializationCompleted = false;
  static const int _minimumSplashDurationSeconds = 3;

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }

  /// Initialize the splash screen flow
  Future<void> initializeSplash() async {
    logInfo('🎬 SplashPresenter: Starting splash screen flow...');

    // Start minimum display timer
    _startMinimumDisplayTimer();

    // Start app initialization
    await _performAppInitialization();
  }

  /// Start the minimum display timer (3+ seconds)
  void _startMinimumDisplayTimer() {
    logInfo(
      '⏱️ Starting minimum splash display timer ($_minimumSplashDurationSeconds seconds)...',
    );

    _minimumDisplayTimer = Timer(
      Duration(seconds: _minimumSplashDurationSeconds),
      () {
        logInfo('⏱️ Minimum splash display time completed');
        _checkIfReadyToNavigate();
      },
    );
  }

  /// Perform app initialization
  Future<void> _performAppInitialization() async {
    logInfo('🔄 Starting app initialization process...');

    await parseDataFromEitherWithUserMessage<bool>(
      task: () => _initializeAppUseCase.execute(),
      onDataLoaded: (bool success) {
        if (success) {
          logInfo('✅ App initialization completed successfully');
          _initializationCompleted = true;
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
    final bool timerCompleted = _minimumDisplayTimer?.isActive == false;

    logInfo('🎯 Checking navigation readiness:');
    logInfo('   - Timer completed: $timerCompleted');
    logInfo('   - Initialization completed: $_initializationCompleted');

    if (timerCompleted && _initializationCompleted) {
      logInfo('🚀 Ready to navigate to main screen');
      _navigateToMainScreen();
    }
  }

  /// Navigate to the main screen
  void _navigateToMainScreen() {
    uiState.value = currentUiState.copyWith(shouldNavigateToMain: true);
    logInfo('📱 Triggering navigation to main screen');
  }

  @override
  void onClose() {
    _minimumDisplayTimer?.cancel();
    super.onClose();
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/config/app_theme_color.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/core/utility/ui_helper.dart';
import 'package:dhaka_bus/features/main/presentation/ui/main_page.dart';
import 'package:dhaka_bus/shared/components/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/splash/presentation/presenter/splash_presenter.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashPresenter _splashPresenter = locate<SplashPresenter>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? textStyle = theme.textTheme.bodyMedium;
    final AppThemeColor appThemeColor = context.color;

    return PresentableWidgetBuilder(
      presenter: _splashPresenter,
      onInit: () => _splashPresenter.initializeSplash(),
      builder: () => Scaffold(
        body: Stack(
          children: [
            // Main splash content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie Animation
                  SizedBox(
                    width: 95.percentWidth,
                    height: 80.percentWidth,
                    child: Lottie.asset(
                      key: const ValueKey('splash_animation'),
                      SvgPath.animBusLoading,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                      addRepaintBoundary: true,
                      frameRate: FrameRate.max,
                    ),
                  ),
                  gapH35,

                  // App title or loading text
                  Text(
                    'Dhaka Bus',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH16,

                  // Dynamic status indicator
                  _buildStatusIndicator(context, textStyle, appThemeColor),
                ],
              ),
            ),

            // Navigation listener
            _buildNavigationListener(context),
          ],
        ),
      ),
    );
  }

  /// Builds the dynamic status indicator based on the UI state.
  Widget _buildStatusIndicator(
    BuildContext context,
    TextStyle? textStyle,
    AppThemeColor appThemeColor,
  ) {
    final state = _splashPresenter.currentUiState;
    final hasError = state.userMessage?.isNotEmpty == true;

    if (hasError) {
      // Show error message and a retry button
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.userMessage!,
            textAlign: TextAlign.center,
            style: textStyle?.copyWith(
              color: appThemeColor.errorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          gapH16,
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            onPressed: () => _splashPresenter.initializeSplash(),
            style: ElevatedButton.styleFrom(
              backgroundColor: appThemeColor.primaryBtn,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    }

    if (state.isLoading) {
      return const LoadingIndicator();
    }

    if (!state.isInitializationComplete) {
      return Text(
        'Initializing...',
        style: textStyle?.copyWith(
          fontStyle: FontStyle.italic,
          color: appThemeColor.captionColor,
        ),
      );
    }

    return Text(
      'Ready!',
      style: textStyle?.copyWith(
        color: appThemeColor.successColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNavigationListener(BuildContext context) {
    return Obx(() {
      final state = _splashPresenter.currentUiState;
      // Only navigate if we should navigate AND haven't navigated yet
      if (state.shouldNavigateToMain && !state.hasNavigated) {
        // Use WidgetsBinding to ensure navigation happens only once per frame
        UiHelper.doOnPageLoaded(() {
          if (context.mounted) {
            _navigateToMainScreen(context);
            // Mark as navigated in the presenter state
            _splashPresenter.markAsNavigated();
          }
        });
      }
      return const SizedBox.shrink();
    });
  }

  void _navigateToMainScreen(BuildContext context) {
    logInfo('🏠 Navigating to MainPage');
    context.navigatorPushReplacement(MainPage());
  }
}

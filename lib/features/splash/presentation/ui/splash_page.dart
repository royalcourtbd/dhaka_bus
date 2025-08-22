import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/features/main/presentation/ui/main_page.dart';
import 'package:lottie/lottie.dart';
import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/splash/presentation/presenter/splash_presenter.dart';
import 'package:dhaka_bus/core/utility/ui_helper.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashPresenter _splashPresenter = locate<SplashPresenter>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      SvgPath.animBusLoading,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App title or loading text
                  Text(
                    'Dhaka Bus',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Loading indicator
                  if (_splashPresenter.currentUiState.isLoading)
                    const CircularProgressIndicator()
                  else if (!_splashPresenter
                      .currentUiState
                      .isInitializationComplete)
                    Text(
                      'Initializing...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    Text(
                      'Ready!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // Navigation listener
            _buildNavigationListener(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationListener() {
    return Obx(() {
      if (_splashPresenter.currentUiState.shouldNavigateToMain) {
        UiHelper.doOnPageLoaded(() {
          _navigateToMainScreen();
        });
      }
      return const SizedBox.shrink();
    });
  }

  void _navigateToMainScreen() {
    logInfo('🏠 Navigating to MainPage');
    Get.to(() => MainPage());
  }
}

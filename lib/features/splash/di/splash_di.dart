import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';

import 'package:dhaka_bus/features/splash/domain/usecase/initialize_app_use_case.dart';
import 'package:dhaka_bus/features/splash/presentation/presenter/splash_presenter.dart';

import 'package:get_it/get_it.dart';

class SplashDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository

    // Use Cases
    serviceLocator.registerLazySingleton(
      () => InitializeAppUseCase(locate(), locate()),
    );

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(SplashPresenter(locate())),
    );
  }
}

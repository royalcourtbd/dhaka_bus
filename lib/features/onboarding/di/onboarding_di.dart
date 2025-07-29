import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:dhaka_bus/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:dhaka_bus/features/onboarding/presentation/presenter/onboarding_presenter.dart';

import 'package:get_it/get_it.dart';

class OnboardingDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository
    serviceLocator.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(),
    );

    // Use Cases

    // Presenters
    serviceLocator.registerFactory(() => loadPresenter(OnboardingPresenter()));
  }
}

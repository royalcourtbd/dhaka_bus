import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:dhaka_bus/features/settings/domain/repositories/settings_repository.dart';
import 'package:dhaka_bus/features/settings/presentation/presenter/settings_presenter.dart';

import 'package:get_it/get_it.dart';

class SettingsDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository
    serviceLocator.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(),
    );

    // Use Cases

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(SettingsPresenter()),
    );
  }
}

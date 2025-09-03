import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/settings/data/datasource/app_settings_remote_data_source.dart';
import 'package:dhaka_bus/features/settings/data/repositories/app_settings_repository_impl.dart';
import 'package:dhaka_bus/features/settings/domain/repositories/app_settings_repository.dart';
import 'package:dhaka_bus/features/settings/domain/usecase/get_app_version_usecase.dart';
import 'package:dhaka_bus/features/settings/presentation/presenter/settings_presenter.dart';

import 'package:get_it/get_it.dart';

class SettingsDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source
    serviceLocator.registerLazySingleton<AppSettingsRemoteDataSource>(
      () => AppSettingsRemoteDataSourceImpl(locate()),
    );

    //  Repository
    serviceLocator.registerLazySingleton<AppSettingsRepository>(
      () => AppSettingsRepositoryImpl(locate(), locate()),
    );

    // Use Cases
    serviceLocator.registerLazySingleton<GetAppVersionUseCase>(
      () => GetAppVersionUseCase(locate(), locate()),
    );

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(SettingsPresenter(locate())),
    );
  }
}

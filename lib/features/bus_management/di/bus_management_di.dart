import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:get_it/get_it.dart';

class BusManagementDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Sources
    serviceLocator.registerLazySingleton<BusRemoteDataSource>(
      () => BusRemoteDataSourceImpl(locate()),
    );

    serviceLocator.registerLazySingleton<RouteRemoteDataSource>(
      () => RouteRemoteDataSourceImpl(locate()),
    );

    serviceLocator.registerLazySingleton<BusLocalDataSource>(
      () => BusLocalDataSourceImpl(locate()),
    );

    serviceLocator.registerLazySingleton<RouteLocalDataSource>(
      () => RouteLocalDataSourceImpl(locate()),
    );

    ///Data Sync Service
    serviceLocator.registerLazySingleton<DataSyncService>(
      () => DataSyncService(locate(), locate(), locate(), locate()),
    );

    //  Repositories
    serviceLocator.registerLazySingleton<BusRepository>(
      () => BusRepositoryImpl(locate(), locate()),
    );

    serviceLocator.registerLazySingleton<RouteRepository>(
      () => RouteRepositoryImpl(locate(), locate()),
    );

    // Use Cases
    serviceLocator
      ..registerLazySingleton(() => GetBusesUseCase(locate(), locate()))
      ..registerLazySingleton(() => GetRoutesUseCase(locate(), locate()))
      ..registerLazySingleton(
        () => GetRoutesByBusIdUseCase(locate(), locate()),
      );

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(BusPresenter(locate(), locate(), locate(), locate())),
    );
  }
}

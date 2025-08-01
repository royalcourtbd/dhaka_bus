import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/bus_management/data/datasource/bus_remote_datasource.dart';
import 'package:dhaka_bus/features/bus_management/data/datasource/route_remote_datasource.dart';
import 'package:dhaka_bus/features/bus_management/data/repositories/bus_repository_impl.dart';
import 'package:dhaka_bus/features/bus_management/data/repositories/route_repository_impl.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/route_repository.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_all_active_buses_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_routes_use_case.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_routes_by_bus_id_use_case.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
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
      () => loadPresenter(BusPresenter(locate(), locate(), locate())),
    );
  }
}

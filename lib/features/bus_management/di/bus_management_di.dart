import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/bus_management/data/datasource/bus_remote_datasource.dart';
import 'package:dhaka_bus/features/bus_management/data/repositories/bus_repository_impl.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:dhaka_bus/features/bus_management/domain/usecase/get_buses_use_case.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:get_it/get_it.dart';

class BusManagementDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source
    serviceLocator.registerLazySingleton<BusRemoteDataSource>(
      () => BusRemoteDataSourceImpl(locate()),
    );

    //  Repository
    serviceLocator.registerLazySingleton<BusRepository>(
      () => BusRepositoryImpl(locate(), locate()),
    );

    // Use Cases
    serviceLocator.registerLazySingleton(
      () => GetBusesUseCase(locate(), locate()),
    );

    // Presenters
    serviceLocator.registerFactory(() => loadPresenter(BusPresenter(locate())));
  }
}

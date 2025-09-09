import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/features/our_project/data/repositories/our_project_repository_impl.dart';
import 'package:dhaka_bus/features/our_project/domain/repositories/our_project_repository.dart';
import 'package:dhaka_bus/features/our_project/presentation/presenter/our_project_presenter.dart';

import 'package:get_it/get_it.dart';

class OurProjectDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository
    serviceLocator.registerLazySingleton<OurProjectRepository>(
      () => OurProjectRepositoryImpl(),
    );

    // Use Cases

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(OurProjectPresenter()),
    );
  }
}

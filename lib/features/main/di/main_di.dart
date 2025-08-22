import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/main/presentation/presenter/main_presenter.dart';

import 'package:get_it/get_it.dart';

class MainDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository

    // Use Cases

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(MainPresenter(locate())),
    );
  }
}

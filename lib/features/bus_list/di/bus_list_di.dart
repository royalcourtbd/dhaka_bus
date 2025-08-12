import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';

import 'package:dhaka_bus/features/bus_list/presentation/presenter/bus_list_presenter.dart';

import 'package:get_it/get_it.dart';

class BusListDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository

    // Use Cases

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(BusListPresenter(locate(), locate())),
    );
  }
}

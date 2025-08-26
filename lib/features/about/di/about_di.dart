import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/features/about/presentation/presenter/about_presenter.dart';

import 'package:get_it/get_it.dart';

class AboutDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source

    //  Repository

    // Use Cases

    // Presenters
    serviceLocator.registerFactory(() => loadPresenter(AboutPresenter()));
  }
}

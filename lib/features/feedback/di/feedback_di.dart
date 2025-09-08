import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/feedback/data/datasource/feedback_remote_data_source.dart';
import 'package:dhaka_bus/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:dhaka_bus/features/feedback/domain/datasource/feedback_data_source.dart';
import 'package:dhaka_bus/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:dhaka_bus/features/feedback/domain/usecase/send_feedback_usecase.dart';
import 'package:dhaka_bus/features/feedback/presentation/presenter/feedback_presenter.dart';
import 'package:get_it/get_it.dart';

class FeedbackDi {
  static Future<void> setup(GetIt serviceLocator) async {
    //  Data Source
    serviceLocator.registerLazySingleton<FeedbackDataSource>(
      () => FeedbackRemoteDataSourceImpl(),
    );

    //  Repository
    serviceLocator.registerLazySingleton<FeedbackRepository>(
      () => FeedbackRepositoryImpl(locate()),
    );

    // Use Cases
    serviceLocator.registerLazySingleton<SendFeedbackUseCase>(
      () => SendFeedbackUseCase(locate(), locate()),
    );

    // Presenters
    serviceLocator.registerFactory(
      () => loadPresenter(FeedbackPresenter(locate())),
    );
  }
}

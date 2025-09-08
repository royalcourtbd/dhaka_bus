import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/feedback/domain/datasource/feedback_data_source.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';
import 'package:dhaka_bus/features/feedback/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackDataSource _dataSource;

  FeedbackRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, bool>> sendFeedback(FeedbackMessage feedback) {
    return _dataSource.sendFeedback(feedback);
  }

  @override
  Future<Either<String, String>> getFeedbackEmail() {
    return _dataSource.getFeedbackEmail();
  }
}

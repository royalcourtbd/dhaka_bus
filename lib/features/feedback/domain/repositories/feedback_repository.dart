import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';

abstract class FeedbackRepository {
  Future<Either<String, bool>> sendFeedback(FeedbackMessage feedback);
  Future<Either<String, String>> getFeedbackEmail();
}

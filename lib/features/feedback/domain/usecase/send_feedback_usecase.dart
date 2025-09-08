import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';
import 'package:dhaka_bus/features/feedback/domain/repositories/feedback_repository.dart';

class SendFeedbackUseCase extends BaseUseCase<bool> {
  final FeedbackRepository _repository;

  SendFeedbackUseCase(this._repository, super.errorMessageHandler);

  Future<Either<String, bool>> execute(FeedbackMessage feedback) {
    return mapResultToEither(() async {
      // Validate the feedback
      if (feedback.subject.trim().isEmpty) {
        throw Exception('Subject cannot be empty');
      }

      if (feedback.message.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }

      if (feedback.senderName.trim().isEmpty) {
        throw Exception('Name cannot be empty');
      }

      if (feedback.senderEmail.trim().isEmpty) {
        throw Exception('Email cannot be empty');
      }

      // Basic email validation
      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
      if (!emailRegex.hasMatch(feedback.senderEmail)) {
        throw Exception('Please enter a valid email address');
      }

      if (feedback.rating < 1 || feedback.rating > 5) {
        throw Exception('Please provide a rating between 1 and 5');
      }

      final result = await _repository.sendFeedback(feedback);
      return result.fold(
        (error) => throw Exception(error),
        (success) => success,
      );
    });
  }
}

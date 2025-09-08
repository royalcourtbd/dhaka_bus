import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/core/services/email_service.dart';
import 'package:dhaka_bus/core/static/constants.dart';
import 'package:dhaka_bus/features/feedback/domain/datasource/feedback_data_source.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';

class FeedbackRemoteDataSourceImpl implements FeedbackDataSource {
  @override
  Future<Either<String, bool>> sendFeedback(FeedbackMessage feedback) async {
    try {
      // Format the email subject and body
      final subject = 'App Feedback: ${feedback.subject}';
      final body = _formatEmailBody(feedback);

      // Send email using the existing email service
      await sendEmail(subject: subject, body: body, email: reportEmailAddress);

      return const Right(true);
    } catch (e) {
      return Left('Failed to send feedback: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> getFeedbackEmail() async {
    try {
      return const Right(reportEmailAddress);
    } catch (e) {
      return Left('Failed to get feedback email: ${e.toString()}');
    }
  }

  String _formatEmailBody(FeedbackMessage feedback) {
    final ratingStars = '⭐' * feedback.rating;

    return '''
Subject: ${feedback.subject}
Type: ${feedback.type.displayName}
Rating: $ratingStars (${feedback.rating}/5)

From: ${feedback.senderName}
Email: ${feedback.senderEmail}
Date: ${feedback.createdAt.toLocal().toString()}

Feedback:
${feedback.message}

---
Sent from Dhaka Bus App - User Feedback
''';
  }
}

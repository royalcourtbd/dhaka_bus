import 'package:dhaka_bus/core/base/base_entity.dart';

class FeedbackMessage extends BaseEntity {
  final String subject;
  final String message;
  final String senderName;
  final String senderEmail;
  final DateTime createdAt;
  final FeedbackType type;
  final int rating;

  const FeedbackMessage({
    required this.subject,
    required this.message,
    required this.senderName,
    required this.senderEmail,
    required this.createdAt,
    required this.type,
    required this.rating,
  });

  @override
  List<Object?> get props => [
    subject,
    message,
    senderName,
    senderEmail,
    createdAt,
    type,
    rating,
  ];
}

enum FeedbackType {
  general('General Feedback', 'সাধারণ মতামত'),
  featureRequest('Feature Request', 'নতুন ফিচার অনুরোধ'),
  uiImprovement('UI/UX Improvement', 'ইউআই/ইউএক্স উন্নতি'),
  busDataAccuracy('Bus Data Accuracy', 'বাস ডেটা নির্ভুলতা'),
  performance('App Performance', 'অ্যাপের পারফরম্যান্স'),
  other('Other', 'অন্যান্য');

  const FeedbackType(this.english, this.bengali);

  final String english;
  final String bengali;

  String get displayName => english;
  String get displayNameBengali => bengali;
}

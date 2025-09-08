import 'package:dhaka_bus/core/base/base_ui_state.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';

class FeedbackUiState extends BaseUiState {
  final String senderName;
  final String senderEmail;
  final String subject;
  final String message;
  final FeedbackType selectedType;
  final int rating;
  final bool isFormValid;
  final bool isSubmitting;

  const FeedbackUiState({
    required super.isLoading,
    required super.userMessage,
    required this.senderName,
    required this.senderEmail,
    required this.subject,
    required this.message,
    required this.selectedType,
    required this.rating,
    required this.isFormValid,
    required this.isSubmitting,
  });

  factory FeedbackUiState.empty() {
    return FeedbackUiState(
      isLoading: false,
      userMessage: '',
      senderName: '',
      senderEmail: '',
      subject: '',
      message: '',
      selectedType: FeedbackType.general,
      rating: 5,
      isFormValid: false,
      isSubmitting: false,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userMessage,
    senderName,
    senderEmail,
    subject,
    message,
    selectedType,
    rating,
    isFormValid,
    isSubmitting,
  ];

  FeedbackUiState copyWith({
    bool? isLoading,
    String? userMessage,
    String? senderName,
    String? senderEmail,
    String? subject,
    String? message,
    FeedbackType? selectedType,
    int? rating,
    bool? isFormValid,
    bool? isSubmitting,
  }) {
    return FeedbackUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      selectedType: selectedType ?? this.selectedType,
      rating: rating ?? this.rating,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

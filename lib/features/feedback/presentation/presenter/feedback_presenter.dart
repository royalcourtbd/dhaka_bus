import 'dart:async';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';
import 'package:dhaka_bus/features/feedback/domain/usecase/send_feedback_usecase.dart';
import 'package:dhaka_bus/features/feedback/presentation/presenter/feedback_ui_state.dart';
import 'package:flutter/material.dart';

class FeedbackPresenter extends BasePresenter<FeedbackUiState> {
  final SendFeedbackUseCase _sendFeedbackUseCase;

  FeedbackPresenter(this._sendFeedbackUseCase);

  final Obs<FeedbackUiState> uiState = Obs<FeedbackUiState>(
    FeedbackUiState.empty(),
  );
  FeedbackUiState get currentUiState => uiState.value;

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _setupTextControllerListeners();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void _setupTextControllerListeners() {
    nameController.addListener(_updateFormValidation);
    emailController.addListener(_updateFormValidation);
    subjectController.addListener(_updateFormValidation);
    messageController.addListener(_updateFormValidation);
  }

  void _updateFormValidation() {
    final isValid = _validateForm();
    uiState.value = currentUiState.copyWith(
      senderName: nameController.text,
      senderEmail: emailController.text,
      subject: subjectController.text,
      message: messageController.text,
      isFormValid: isValid,
    );
  }

  bool _validateForm() {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        subjectController.text.trim().isNotEmpty &&
        messageController.text.trim().isNotEmpty &&
        _isValidEmail(emailController.text.trim()) &&
        currentUiState.rating > 0;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  void onTypeChanged(FeedbackType type) {
    uiState.value = currentUiState.copyWith(selectedType: type);
  }

  void onRatingChanged(int rating) {
    uiState.value = currentUiState.copyWith(rating: rating);
    _updateFormValidation();
  }

  Future<void> sendFeedback() async {
    if (!currentUiState.isFormValid || currentUiState.isSubmitting) return;

    uiState.value = currentUiState.copyWith(isSubmitting: true);

    final feedback = FeedbackMessage(
      subject: subjectController.text.trim(),
      message: messageController.text.trim(),
      senderName: nameController.text.trim(),
      senderEmail: emailController.text.trim(),
      createdAt: DateTime.now(),
      type: currentUiState.selectedType,
      rating: currentUiState.rating,
    );

    await parseDataFromEitherWithUserMessage<bool>(
      task: () => _sendFeedbackUseCase.execute(feedback),
      onDataLoaded: (success) {
        if (success) {
          _clearForm();
          addUserMessage(
            'Thank you for your feedback! We appreciate your input.',
          );
        }
      },
      showLoading: false, // We handle our own loading state
    );

    uiState.value = currentUiState.copyWith(isSubmitting: false);
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();

    uiState.value = FeedbackUiState.empty();
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/external_libs/user_input_field/user_input_field.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/features/feedback/domain/entities/feedback_message.dart';
import 'package:dhaka_bus/features/feedback/presentation/presenter/feedback_presenter.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final FeedbackPresenter _presenter = locate<FeedbackPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Send Feedback', centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sixteenPx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(sixteenPx),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(twelvePx),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.feedback,
                        color: Theme.of(context).primaryColor,
                        size: twentyFourPx,
                      ),
                      SizedBox(width: twelvePx),
                      Expanded(
                        child: Text(
                          'Share Your Feedback',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: twelvePx),
                  Text(
                    'We value your opinion! Your feedback helps us improve the Dhaka Bus app. Please share your thoughts, suggestions, or report any issues you have encountered.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            SizedBox(height: twentyFourPx),
            Container(
              padding: EdgeInsets.all(sixteenPx),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(twelvePx),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate Your Experience',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: twelvePx),
                  Text(
                    'How would you rate your overall experience with the app?',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  SizedBox(height: sixteenPx),
                  Obx(() {
                    final currentRating = _presenter.currentUiState.rating;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return GestureDetector(
                          onTap: () => _presenter.onRatingChanged(starValue),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: fourPx),
                            child: Icon(
                              starValue <= currentRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: starValue <= currentRating
                                  ? Colors.amber
                                  : Colors.grey[400],
                              size: thirtyTwoPx,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: twentyFourPx),
            Container(
              padding: EdgeInsets.all(sixteenPx),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(twelvePx),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feedback Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: sixteenPx),

                  // Name Field with Label
                  Text(
                    'Name *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: eightPx),
                  UserInputField(
                    textEditingController: _presenter.nameController,
                    hintText: 'Your Name',
                    prefixIconPath: SvgPath.icMail,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: sixteenPx),

                  // Email Field with Label
                  Text(
                    'Email Address *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: eightPx),
                  UserInputField(
                    textEditingController: _presenter.emailController,
                    hintText: 'your.email@example.com',
                    prefixIconPath: SvgPath.icMail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: sixteenPx),

                  // Feedback Type Dropdown
                  _buildTypeDropdown(context),
                  SizedBox(height: sixteenPx),

                  // Subject Field with Label
                  Text(
                    'Subject *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: eightPx),
                  UserInputField(
                    textEditingController: _presenter.subjectController,
                    hintText: 'Brief summary of your feedback',
                    prefixIconPath: SvgPath.icMail,
                  ),
                  SizedBox(height: sixteenPx),

                  // Message Field with Label
                  Text(
                    'Your Feedback *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: eightPx),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(twentyFivePx),
                    ),
                    child: TextFormField(
                      controller: _presenter.messageController,
                      decoration: InputDecoration(
                        hintText:
                            'Please share your detailed feedback, suggestions, or report any issues...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(sixteenPx),
                      ),
                      maxLines: 6,
                      minLines: 4,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  SizedBox(height: twentyFourPx),

                  // Submit Button
                  Obx(() {
                    final currentState = _presenter.currentUiState;
                    final isButtonEnabled =
                        currentState.isFormValid && !currentState.isSubmitting;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? _presenter.sendFeedback
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: sixteenPx),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(eightPx),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                        ),
                        child: currentState.isSubmitting
                            ? SizedBox(
                                height: twentyPx,
                                width: twentyPx,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Send Feedback',
                                style: TextStyle(
                                  fontSize: sixteenPx,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Type *',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: eightPx),
        Container(
          padding: EdgeInsets.symmetric(horizontal: twelvePx),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(twentyFivePx),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<FeedbackType>(
                value: _presenter.currentUiState.selectedType,
                isExpanded: true,
                hint: Text('Select feedback type'),
                onChanged: (FeedbackType? newValue) {
                  if (newValue != null) {
                    _presenter.onTypeChanged(newValue);
                  }
                },
                items: FeedbackType.values.map<DropdownMenuItem<FeedbackType>>((
                  FeedbackType type,
                ) {
                  return DropdownMenuItem<FeedbackType>(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

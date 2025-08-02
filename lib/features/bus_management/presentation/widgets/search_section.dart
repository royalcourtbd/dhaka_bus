import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/external_libs/user_input_field/user_input_field.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/utility/number_utility.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/shared/components/ontap_widget.dart';
import 'package:dhaka_bus/shared/components/submit_button.dart';
import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key, required this.busPresenter});
  final BusPresenter busPresenter;
  static const Color _inputFieldColor = Color(0xffEEEEEE);
  static const EdgeInsets _horizontalPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets _verticalPadding = EdgeInsets.symmetric(
    vertical: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: _horizontalPadding.add(_verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show loading message if stops are not loaded yet
                if (busPresenter.currentUiState.uniqueStops.isEmpty &&
                    busPresenter.currentUiState.isLoading)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orange.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'স্টপের তালিকা লোড হচ্ছে...',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                _buildAutocompleteField(
                  hintText: 'Enter starting station name',
                  controller: busPresenter.startingStationNameController,
                  options: busPresenter.currentUiState.uniqueStops,
                  isEnabled: busPresenter.currentUiState.uniqueStops.isNotEmpty,
                ),
                gapH16,
                _buildAutocompleteField(
                  hintText: 'Enter destination station name',
                  controller: busPresenter.destinationStationNameController,
                  options: busPresenter.currentUiState.uniqueStops,
                  isEnabled: busPresenter.currentUiState.uniqueStops.isNotEmpty,
                ),
                gapH16,
                SubmitButton(
                  title: 'Search',
                  buttonColor:
                      busPresenter.currentUiState.uniqueStops.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  textColor: Colors.white,
                  theme: Theme.of(context),
                  onTap: busPresenter.currentUiState.uniqueStops.isNotEmpty
                      ? () {
                          busPresenter.findBusesByRoute();
                        }
                      : null,
                ),
              ],
            ),
          ),
          SwapButton(busPresenter: busPresenter),
        ],
      ),
    );
  }

  Widget _buildAutocompleteField({
    required String hintText,
    required TextEditingController controller,
    required List<String> options,
    bool isEnabled = true,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty || !isEnabled) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        if (isEnabled) {
          controller.text = selection;
        }
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Sync presenter's controller with field's controller
            fieldController.text = controller.text;
            fieldController.addListener(() {
              controller.text = fieldController.text;
            });

            return UserInputField(
              textEditingController: fieldController,
              hintText: isEnabled ? hintText : 'স্টপের তালিকা লোড হচ্ছে...',
              focusNode: fieldFocusNode,
              prefixIconPath: SvgPath.icSearch,
              fillColor: isEnabled ? _inputFieldColor : Colors.grey.shade200,
              onTapSuffixIcon: isEnabled
                  ? () {
                      fieldController.clear();
                      controller.clear();
                      busPresenter.clearSearch();
                    }
                  : null,
              suffixIconPath: (fieldController.text.isNotEmpty && isEnabled)
                  ? SvgPath.icCross
                  : null,
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                animationDuration: 300.inMilliseconds,
                borderOnForeground: true,
                borderRadius: radius15,
                shadowColor: Color(0xff888888).withValues(alpha: .15),

                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 40.percentHeight),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      final bool isLastItem = index == options.length - 1;

                      return OnTapWidget(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: isLastItem
                                ? null
                                : Border(
                                    bottom: BorderSide(
                                      color: Color(0xffDEDEDE),
                                      width: 0.5,
                                    ),
                                  ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(option),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }
}

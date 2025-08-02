import 'package:dhaka_bus/core/external_libs/user_input_field/user_input_field.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
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
                _buildAutocompleteField(
                  hintText: 'Enter starting station name',
                  controller: busPresenter.startingStationNameController,
                  options: busPresenter.currentUiState.uniqueStops,
                ),
                gapH16,
                _buildAutocompleteField(
                  hintText: 'Enter destination station name',
                  controller: busPresenter.destinationStationNameController,
                  options: busPresenter.currentUiState.uniqueStops,
                ),
                gapH16,
                SubmitButton(
                  title: 'Search',
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  theme: Theme.of(context),
                  onTap: () {
                    busPresenter.findBusesByRoute();
                  },
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
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
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
              hintText: hintText,
              focusNode: fieldFocusNode,
              prefixIconPath: SvgPath.icSearch,
              fillColor: _inputFieldColor,
              suffixIconPath: fieldController.text.isNotEmpty
                  ? SvgPath.icSearch
                  : null,
            );

            // return TextField(
            //   controller: fieldController,
            //   focusNode: fieldFocusNode,
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.symmetric(
            //       vertical: 10,
            //       horizontal: 15,
            //     ),
            //     hintText: hintText,
            //     filled: true,
            //     fillColor: _inputFieldColor,
            //     prefixIcon: Padding(
            //       padding: const EdgeInsets.all(12.0),
            //       child: Icon(Icons.search),
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(twelvePx),
            //       borderSide: BorderSide.none,
            //     ),
            //     suffixIcon: fieldController.text.isNotEmpty
            //         ? IconButton(
            //             icon: const Icon(Icons.clear),
            //             onPressed: () {
            //               fieldController.clear();
            //               controller.clear();
            //               busPresenter.clearSearch();
            //             },
            //           )
            //         : null,
            //   ),
            // );
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
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(option),
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

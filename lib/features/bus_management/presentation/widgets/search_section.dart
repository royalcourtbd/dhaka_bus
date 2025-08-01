import 'package:dhaka_bus/core/external_libs/user_input_field/src/user_input_field_widget.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
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
                _buildInputField(
                  hintText: 'Enter starting station name',
                  textEditingController:
                      busPresenter.startingStationNameController,
                ),
                gapH16,
                _buildInputField(
                  hintText: 'Enter destination station name',
                  textEditingController:
                      busPresenter.destinationStationNameController,
                ),
              ],
            ),
          ),
          SwapButton(busPresenter: busPresenter),
        ],
      ),
    );
  }

  UserInputField _buildInputField({
    required String hintText,
    required TextEditingController textEditingController,
  }) {
    return UserInputField(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      hintText: hintText,
      fillColor: _inputFieldColor,
      prefixIconPath: SvgPath.icSearch,
      textEditingController: textEditingController,
    );
  }
}

import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/external_libs/user_input_field/src/user_input_field_widget.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/swap_button.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class BusRoutesDisplayPage extends StatelessWidget {
  BusRoutesDisplayPage({super.key});
  final BusPresenter busPresenter = locate<BusPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '🚌 Bus & Routes', isRoot: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            // color: Colors.blueAccent,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: twentyPx,
                    vertical: tenPx,
                  ),
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
          ),
        ],
      ),
    );
  }

  UserInputField _buildInputField({
    required String hintText,
    required TextEditingController textEditingController,
  }) {
    return UserInputField(
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      hintText: hintText,
      fillColor: Color(0xffEEEEEE),
      prefixIconPath: SvgPath.icSearch,
      textEditingController: busPresenter.startingStationNameController,
    );
  }
}

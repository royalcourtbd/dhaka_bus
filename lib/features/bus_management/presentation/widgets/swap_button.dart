import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({super.key, required this.busPresenter});

  final BusPresenter busPresenter;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: fortyPx,
      right: 17.percentWidth,
      child: GestureDetector(
        onTap: () {
          busPresenter.swapLocations();
        },
        child: Container(
          width: 15.percentWidth,
          height: 15.percentWidth,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: const Icon(Icons.swap_vert, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

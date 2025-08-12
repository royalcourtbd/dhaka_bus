import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:flutter/material.dart';

class BusEmptyStateWidget extends StatelessWidget {
  const BusEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_bus_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          gapH16,
          Text(
            'No buses available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          gapH8,
          Text(
            'Please try refreshing the page',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

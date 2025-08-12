import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/shared/components/data_source_indicator.dart';
import 'package:flutter/material.dart';

class BusDataSourceIndicator extends StatelessWidget {
  final BusPresenter busPresenter;

  const BusDataSourceIndicator({super.key, required this.busPresenter});

  @override
  Widget build(BuildContext context) {
    final dataSource = busPresenter.currentUiState.lastDataSource;
    final isFirstTime = busPresenter.currentUiState.isFirstTimeLoad;

    DataSource sourceType;
    String? customMessage;

    switch (dataSource) {
      case 'firebase':
        sourceType = DataSource.firebase;
        customMessage = isFirstTime
            ? '🔥 First time loading from Firebase'
            : '🔄 Updated from Firebase';
        break;
      case 'localStorage':
        sourceType = DataSource.localStorage;
        customMessage = '⚡ Quickly loaded from Local Storage';
        break;
      case 'loading':
        sourceType = DataSource.loading;
        break;
      default:
        return const SizedBox.shrink();
    }

    return DataSourceIndicator(
      dataSource: sourceType,
      customMessage: customMessage,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}

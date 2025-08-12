import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/bus_data_source_indicator.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/bus_routes_list_widget.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/search_section.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';

import 'package:flutter/material.dart';

class BusRoutesDisplayPage extends StatelessWidget {
  BusRoutesDisplayPage({super.key});

  final BusPresenter busPresenter = locate<BusPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: busPresenter,
      builder: () => Scaffold(
        appBar: const CustomAppBar(title: '🚌 Bus & Routes', isRoot: true),
        body: Column(
          children: [
            SearchSection(busPresenter: busPresenter),
            // Data source indicator
            if (!busPresenter.currentUiState.isLoading &&
                busPresenter.currentUiState.lastDataSource != null)
              BusDataSourceIndicator(busPresenter: busPresenter),
            BusRoutesListWidget(busPresenter: busPresenter),
          ],
        ),
      ),
    );
  }
}

// lib/presentation/bus/pages/bus_demo_page.dart

import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:flutter/material.dart';

class BusDemoPage extends StatelessWidget {
  BusDemoPage({super.key});
  final BusPresenter _busPresenter = locate<BusPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: _busPresenter,
      onInit: () => _busPresenter.loadBuses(),
      builder: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🚌 Bus Demo Page'),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          body: ListView.builder(
            itemCount: _busPresenter.currentUiState.allBuses.length,
            itemBuilder: (context, index) {
              final bus = _busPresenter.currentUiState.allBuses[index];
              return ListTile(
                title: Text(bus.busNameEn),
                subtitle: Text(bus.busNameBn),
                trailing: bus.isActive
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
                onTap: () {},
              );
            },
          ),
        );
      },
    );
  }
}

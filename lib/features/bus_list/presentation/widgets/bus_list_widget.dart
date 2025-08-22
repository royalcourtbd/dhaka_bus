import 'package:dhaka_bus/features/bus_list/bus_list_export.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:flutter/material.dart';

class BusListWidget extends StatelessWidget {
  final BusListPresenter presenter;

  const BusListWidget({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: presenter.refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: presenter.getDisplayBusesCount(),
        itemBuilder: (context, index) {
          final bus = presenter.getBusAt(index);
          final routeData = presenter.getRouteDataForBus(bus.busId);
          final cardId = presenter.getCardId(bus.busId, index);

          return BusRouteCard(
            key: Key('bus_list_card_$index'),
            bus: bus,
            route: routeData.fullRoute,
            description: routeData.description,
            isExpanded: presenter.isCardExpanded(cardId),
            onTap: () => presenter.toggleCardExpansion(cardId),
          );
        },
      ),
    );
  }
}

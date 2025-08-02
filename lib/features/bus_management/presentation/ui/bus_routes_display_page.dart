import 'package:dhaka_bus/core/di/service_locator.dart';

import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/search_section.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class BusRoutesDisplayPage extends StatelessWidget {
  BusRoutesDisplayPage({super.key});

  final BusPresenter busPresenter = locate<BusPresenter>();

  // Cache commonly used values
  static const String _defaultRouteText = 'রুট তথ্য নেই';
  static const EdgeInsets _horizontalPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );

  static const Color _backgroundColor = Color(0xfff5f5f5);

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: busPresenter,
      builder: () => Scaffold(
        backgroundColor: _backgroundColor,
        appBar: const CustomAppBar(title: '🚌 Bus & Routes', isRoot: true),
        body: Column(
          children: [
            SearchSection(busPresenter: busPresenter),
            _buildBusRoutesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusRoutesList() {
    final bool isSearchActive =
        busPresenter.currentUiState.searchQuery.isNotEmpty;
    final List<BusEntity> busesToDisplay = isSearchActive
        ? busPresenter.currentUiState.searchResults
        : busPresenter.currentUiState.allBuses;

    if (busesToDisplay.isEmpty && isSearchActive) {
      return const Expanded(
        child: Center(child: Text('No buses found for the selected route.')),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: _horizontalPadding,
        itemCount: busesToDisplay.length,
        itemBuilder: (context, index) =>
            _buildBusRouteCard(index, busesToDisplay),
      ),
    );
  }

  Widget _buildBusRouteCard(int index, List<BusEntity> buses) {
    final bus = buses[index];
    final routes = busPresenter.currentUiState.busRoutes[bus.busId] ?? [];
    final cardId = 'route_${bus.busId}_$index';

    // Calculate route data once and cache it
    final routeData = _calculateRouteData(routes);

    return BusRouteCard(
      key: Key('bus_route_card_$index'),
      bus: bus,
      route: routeData.fullRoute,
      description: routeData.shortRoute,
      isExpanded: busPresenter.isCardExpanded(cardId),
      onTap: () => busPresenter.toggleCardExpansion(cardId),
    );
  }

  // Optimized route calculation with early returns
  RouteData _calculateRouteData(List<RouteEntity> routes) {
    if (routes.isEmpty) {
      return _defaultRouteData;
    }

    final firstRoute = routes.first;
    final stops = firstRoute.stops;

    if (stops.isEmpty) {
      return _defaultRouteData;
    }

    if (stops.length == 1) {
      return RouteData(fullRoute: stops.first, shortRoute: stops.first);
    }

    return RouteData(
      fullRoute: stops.join(' → '),
      shortRoute: '${stops.first} → ${stops.last}',
    );
  }

  // Cache default route data to avoid repeated object creation
  static const RouteData _defaultRouteData = RouteData(
    fullRoute: _defaultRouteText,
    shortRoute: _defaultRouteText,
  );
}

// Helper class for route data
class RouteData {
  final String fullRoute;
  final String shortRoute;

  const RouteData({required this.fullRoute, required this.shortRoute});
}

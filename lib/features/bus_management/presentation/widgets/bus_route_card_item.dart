import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/bus_route_card_widget.dart';
import 'package:flutter/material.dart';

class BusRouteCardItem extends StatelessWidget {
  final int index;
  final List<BusEntity> buses;
  final BusPresenter busPresenter;

  // Cache commonly used values
  static const String _defaultRouteText = 'Route Information Not Available';

  const BusRouteCardItem({
    super.key,
    required this.index,
    required this.buses,
    required this.busPresenter,
  });

  @override
  Widget build(BuildContext context) {
    final bus = buses[index];
    final routes = busPresenter.currentUiState.busRoutes[bus.busId] ?? [];
    final cardId = 'route_${bus.busId}_$index';

    // Calculate route data once and cache it
    final routeData = _calculateRouteData(routes);

    // Get search status and terms for highlighting
    final isSearchActive = busPresenter.currentUiState.searchQuery.isNotEmpty;
    final String? origin = isSearchActive
        ? busPresenter.currentUiState.startingStation.trim()
        : null;
    final String? destination = isSearchActive
        ? busPresenter.currentUiState.destinationStation.trim()
        : null;

    return BusRouteCard(
      key: Key('bus_route_card_$index'),
      bus: bus,
      route: routeData.fullRoute,
      description: routeData.shortRoute,
      isExpanded: busPresenter.isCardExpanded(cardId),
      onTap: () => busPresenter.toggleCardExpansion(cardId),
      originStop: origin,
      destinationStop: destination,
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

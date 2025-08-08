import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/external_libs/feedback/customizable_feedback_widget.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';

import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/search_section.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:dhaka_bus/shared/components/skeleton_widgets/bus_route_card_skeleton.dart';
import 'package:dhaka_bus/shared/components/data_source_indicator.dart';
import 'package:flutter/material.dart';

class BusRoutesDisplayPage extends StatelessWidget {
  BusRoutesDisplayPage({super.key});

  final BusPresenter busPresenter = locate<BusPresenter>();

  // Cache commonly used values
  static const String _defaultRouteText = 'Route Information Not Available';
  static const EdgeInsets _horizontalPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );

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
              _buildDataSourceIndicator(),
            _buildBusRoutesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSourceIndicator() {
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

  Widget _buildBusRoutesList(BuildContext context) {
    final bool isLoading = busPresenter.currentUiState.isLoading;
    final bool isSearchActive =
        busPresenter.currentUiState.searchQuery.isNotEmpty;
    final List<BusEntity> busesToDisplay = isSearchActive
        ? busPresenter.currentUiState.searchResults
        : busPresenter.currentUiState.allBuses;

    // Show skeleton loading when data is being loaded
    if (isLoading && busesToDisplay.isEmpty) {
      return Expanded(
        child: Column(
          children: [
            // Loading status indicator
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.color.primaryColor50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.color.primaryColor200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Data Loading...',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Skeleton cards
            Expanded(
              child: ListView.builder(
                padding: _horizontalPadding,
                itemCount: 8, // Show 8 skeleton cards while loading
                itemBuilder: (context, index) => const BusRouteCardSkeleton(),
              ),
            ),
          ],
        ),
      );
    }

    if (busesToDisplay.isEmpty && isSearchActive) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomizableFeedbackWidget(
            messageTitle: 'No buses found for the selected route.',
          ),
        ),
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

    // Get search status and terms for highlighting
    final isSearchActive = busPresenter.currentUiState.searchQuery.isNotEmpty;
    final String? origin = isSearchActive
        ? busPresenter.startingStationNameController.text.trim()
        : null;
    final String? destination = isSearchActive
        ? busPresenter.destinationStationNameController.text.trim()
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

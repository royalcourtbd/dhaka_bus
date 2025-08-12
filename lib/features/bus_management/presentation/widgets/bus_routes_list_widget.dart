import 'package:dhaka_bus/core/external_libs/feedback/customizable_feedback_widget.dart';
import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/bus_route_card_item.dart';
import 'package:dhaka_bus/shared/components/skeleton_widgets/bus_route_card_skeleton.dart';
import 'package:flutter/material.dart';

class BusRoutesListWidget extends StatelessWidget {
  final BusPresenter busPresenter;

  static const EdgeInsets _horizontalPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );

  const BusRoutesListWidget({super.key, required this.busPresenter});

  @override
  Widget build(BuildContext context) {
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
        itemBuilder: (context, index) => BusRouteCardItem(
          index: index,
          buses: busesToDisplay,
          busPresenter: busPresenter,
        ),
      ),
    );
  }
}

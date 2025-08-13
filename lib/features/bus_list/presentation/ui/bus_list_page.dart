import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/external_libs/feedback/feedback.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_list/presentation/presenter/bus_list_presenter.dart';
import 'package:dhaka_bus/features/bus_list/presentation/widgets/bus_empty_state_widget.dart';
import 'package:dhaka_bus/features/bus_list/presentation/widgets/bus_list_widget.dart';
import 'package:dhaka_bus/features/bus_list/presentation/widgets/bus_loading_widget.dart';
import 'package:dhaka_bus/features/bus_list/presentation/widgets/bus_search_widget.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class BusListPage extends StatelessWidget {
  BusListPage({super.key});

  final BusListPresenter busListPresenter = locate<BusListPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: busListPresenter,
      builder: () => Scaffold(
        appBar: const CustomAppBar(
          title: 'Bus List',
          isRoot: true,
          centerTitle: true,
        ),
        body: Column(
          children: [
            BusSearchWidget(
              controller: busListPresenter.searchController,
              hintText: 'Search buses by name...',
              onChanged: busListPresenter.searchBuses,
              onClear: () {
                busListPresenter.clearSearch();
              },
            ),
            gapH5,
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Let presenter decide what to show
    if (busListPresenter.shouldShowLoading()) {
      return const BusLoadingWidget();
    }

    if (busListPresenter.shouldShowNoSearchResults()) {
      return CustomizableFeedbackWidget(
        messageTitle: 'No buses found',
        messageDescription: 'Try searching with a different bus name',
      );
    }

    if (busListPresenter.shouldShowEmptyState()) {
      return const BusEmptyStateWidget();
    }

    return BusListWidget(presenter: busListPresenter);
  }
}

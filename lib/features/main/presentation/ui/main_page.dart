import 'package:dhaka_bus/features/about/presentation/ui/about_page.dart';
import 'package:dhaka_bus/features/bus_list/presentation/ui/bus_list_page.dart';
import 'package:dhaka_bus/features/bus_management/presentation/ui/bus_routes_display_page.dart';
import 'package:dhaka_bus/features/settings/presentation/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/main/main_export.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final MainPresenter _mainPresenter = locate<MainPresenter>();

  final List<Widget> _pages = <Widget>[
    // BusRoutesDisplayPage(),
    AboutPage(),
    BusListPage(),

    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleTapBackToExitApp(
      mainPresenter: _mainPresenter,
      child: PresentableWidgetBuilder(
        presenter: _mainPresenter,
        builder: () {
          final MainUiState state = _mainPresenter.currentUiState;
          return Scaffold(
            body: state.selectedBottomNavIndex < _pages.length
                ? _pages[state.selectedBottomNavIndex]
                : _pages[0], // Default to first page if index out of range
            bottomNavigationBar: MainNavigationBar(
              selectedIndex: state.selectedBottomNavIndex,
              onDestinationSelected: (index) {
                _mainPresenter.changeNavigationIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}

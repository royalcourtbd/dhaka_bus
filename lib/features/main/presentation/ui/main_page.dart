import 'package:dhaka_bus/features/bus_management/presentation/ui/buses_list_page.dart.dart';
import 'package:flutter/material.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/core/utility/navigation_helpers.dart';
import 'package:dhaka_bus/features/main/presentation/presenter/main_presenter.dart';
import 'package:dhaka_bus/features/main/presentation/presenter/main_ui_state.dart';
import 'package:dhaka_bus/features/main/presentation/widgets/double_tap_back_to_exit_app.dart';
import 'package:dhaka_bus/features/main/presentation/widgets/main_navigation_bar.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final MainPresenter _mainPresenter = locate<MainPresenter>();

  final List<Widget> _pages = <Widget>[
    BusDemoPage(),
    BusDemoPage(),
    BusDemoPage(),
    BusDemoPage(),
    BusDemoPage(),
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
                if (index == 3) {
                  showMessage(message: 'Coming soon');
                  return;
                }
                _mainPresenter.changeNavigationIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}

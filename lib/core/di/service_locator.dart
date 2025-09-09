// Implementation Note:
//
// The app utilizes the **Service Locator Pattern** to manage dependencies.
//
// The Service Locator Pattern is a design pattern that improves modularity and
// maintainability in our codebase. By decoupling the code from direct dependency
// references, it allows for easier substitution or addition of dependencies in
// the future.
//
// To understand the Service Locator Pattern in more detail, you can refer to
// the following resource: https://stackify.com/service-locator-pattern/.
//
// This pattern simplifies the process of replacing or adding dependencies.
// Instead of modifying every object that relies on a particular dependency, we
// only need to update the service locator itself. This centralization reduces
// code changes and minimizes potential errors.
import 'package:dhaka_bus/features/about/di/about_di.dart';
import 'package:get_it/get_it.dart';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/setup/service_setup.dart';
import 'package:dhaka_bus/features/app_management/di/app_management_di.dart';
import 'package:dhaka_bus/features/main/di/main_di.dart';
import 'package:dhaka_bus/features/onboarding/di/onboarding_di.dart';
import 'package:dhaka_bus/features/bus_management/di/bus_management_di.dart';
import 'package:dhaka_bus/features/settings/di/settings_di.dart';
import 'package:dhaka_bus/features/bus_list/di/bus_list_di.dart';
import 'package:dhaka_bus/features/splash/di/splash_di.dart';
import 'package:dhaka_bus/features/feedback/di/feedback_di.dart';
import 'package:dhaka_bus/features/our_project/di/our_project_di.dart';

final GetIt _serviceLocator = GetIt.instance;

// This code implements a wrapper function around the `get` function from the
// `get_it` package. The purpose of this wrapper is to provide a simplified and
// centralized way of retrieving registered instances of classes.
//
// By using this wrapper instead of directly calling the get function, we avoid
// tight coupling to the specific service locator implementation, which can lead
// to vendor lock-in. This abstraction allows for flexibility in choosing a
// different service locator plugin in the future if needed.
//
// The wrapper function encapsulates the complexity of the service locator and
// provides a cleaner and more readable interface for retrieving dependencies
// throughout the codebase.

/// Provides a way to retrieve an instance of a class registered
/// with the service locator.
T locate<T extends Object>() => _serviceLocator.get<T>();

void dislocate<T extends BasePresenter>() => unloadPresenterManually<T>();

class ServiceLocator {
  ServiceLocator._();

  /// Sets up the whole dependency injection system by calling various setup
  /// methods in a certain order.
  ///
  /// Also provides an optional flag to only start services and skip the other
  /// setup steps.
  ///
  /// Ensures that all necessary dependencies are initialized before starting
  /// the application.
  static Future<void> setUp({bool startOnlyService = false}) async {
    // final ServiceLocator locator = ServiceLocator._();

    final ServiceSetup setUpService = ServiceSetup(_serviceLocator);
    await setUpService.setup();
    if (startOnlyService) return;

    //================================

    // Feature DI setup
    await AppManagementDi.setup(_serviceLocator);

    //Feature DI setup
    await OurProjectDi.setup(_serviceLocator);
    await FeedbackDi.setup(_serviceLocator);

    await AboutDi.setup(_serviceLocator);
    await SplashDi.setup(_serviceLocator);
    await BusListDi.setup(_serviceLocator);
    await SettingsDi.setup(_serviceLocator);
    await BusManagementDi.setup(_serviceLocator);
    await OnboardingDi.setup(_serviceLocator);
    await MainDi.setup(_serviceLocator);
  }
}

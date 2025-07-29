import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/features/app_management/domain/usecase/determine_first_run_use_case.dart';
import 'package:dhaka_bus/dhaka_bus_app.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeApp();
    runApp(InitialApp(isFirstRun: await _checkFirstRun()));
  }, (error, stackTrace) => (error, stackTrace, fatal: true));
}

Future<void> _initializeApp() async {
  //await loadEnv();
  await ServiceLocator.setUp();
}

Future<bool> _checkFirstRun() {
  return locate<DetermineFirstRunUseCase>().execute();
}

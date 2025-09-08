import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhaka_bus/features/settings/data/models/app_settings_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';
import 'package:synchronized/synchronized.dart';

/// By separating the Firebase code into its own class, we can make it easier to
/// replace Firebase with another backend-as-a-service provider in the future.
///
/// This is because the rest of the app only depends on the public interface of
/// the `BackendAsAService` class, and not on the specific implementation details
/// of Firebase.
/// Therefore, if we decide to switch to a different backend-as-a-service
/// provider, we can simply create a new class that implements the same public
/// interface and use that instead.
///
/// This can help improve the flexibility of the app and make it easier to adapt
/// to changing business requirements or market conditions.
/// It also reduces the risk of vendor lock-in, since we are not tightly
/// coupling our app to a specific backend-as-a-service provider.
///
/// Overall, separating Firebase code into its own class can help make our app
/// more future-proof and adaptable to changing needs.
class BackendAsAService {
  BackendAsAService() {
    _initAnalytics();
  }
  late final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  late final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final Lock _listenToDeviceTokenLock = Lock();
  String? _inMemoryDeviceToken;

  static const String busesCollection = 'buses';
  static const String routesCollection = 'routes';
  static const String noticeCollection = 'notice';
  static const String settingsCollection = 'settings';
  static const String appVersion = 'app_version';
  static const String noticeDoc = 'notice-bn';
  static const String appUpdateDoc = 'app-update';
  static const String deviceTokensCollection = 'device_tokens';
  static const String isActive = 'is_active';

  void _initAnalytics() {
    catchVoid(() {
      _analytics
          .setAnalyticsCollectionEnabled(true)
          .then((_) => _analytics.logAppOpen());
    });
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await catchFutureOrVoid(() async {
      await _analytics.logEvent(name: name, parameters: parameters);
    });
  }

  Future<Map<String, dynamic>> getAppUpdateInfo() async {
    Map<String, dynamic>? appUpdateInfo = {};
    appUpdateInfo = await catchAndReturnFuture(() async {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _fireStore.collection(noticeCollection).doc(appUpdateDoc).get();
      return docSnapshot.data();
    });
    return appUpdateInfo ?? {};
  }

  Future<void> listenToDeviceToken({
    required void Function(String) onTokenFound,
  }) async => catchFutureOrVoid(
    () async => await _listenToDeviceToken(onTokenFound: onTokenFound),
  );

  Future<void> _listenToDeviceToken({
    required void Function(String) onTokenFound,
  }) async {
    // prevents this function to be called multiple times in short period
    await _listenToDeviceTokenLock.synchronized(() async {
      catchFutureOrVoid(() async {
        _inMemoryDeviceToken ??= await _messaging.getToken();
        logDebug("Device token refreshed -> $_inMemoryDeviceToken");
        if (_inMemoryDeviceToken != null) onTokenFound(_inMemoryDeviceToken!);

        _messaging.onTokenRefresh.listen((String? token) {
          logDebug("Device token refreshed -> $token");
          if (token != null) onTokenFound(token);
        });
      });
    });
  }

  ///================================

  /// 🚌 Get ALL ACTIVE buses for offline storage
  /// This replaces individual bus operations - fetches only active buses
  Future<List<Map<String, dynamic>>> getAllActiveBuses() async {
    return await catchAndReturnFuture<List<Map<String, dynamic>>>(() async {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await _fireStore
                  .collection(busesCollection)
                  .where(isActive, isEqualTo: true) // Only active buses
                  .get();

          final List<Map<String, dynamic>> buses = querySnapshot.docs.map((
            doc,
          ) {
            final Map<String, dynamic> data = doc.data();

            return {
              ...data,
              'id': doc.id, // Firebase document ID
            };
          }).toList();

          // Log service type breakdown for debugging
          final Map<String, int> serviceTypes = {};
          for (final bus in buses) {
            final serviceType = bus['service_type'] as String? ?? 'Unknown';
            serviceTypes[serviceType] = (serviceTypes[serviceType] ?? 0) + 1;
          }

          return buses;
        }) ??
        [];
  }

  /// 🛣️ Get ALL routes for offline storage
  /// This replaces individual route operations - fetches all routes
  Future<List<Map<String, dynamic>>> getAllRoutes() async {
    return await catchAndReturnFuture<List<Map<String, dynamic>>>(() async {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await _fireStore.collection(routesCollection).get();

          final List<Map<String, dynamic>> routes = querySnapshot.docs.map((
            doc,
          ) {
            final data = doc.data();
            // Add document ID as 'id' field for consistency
            return {
              ...data,
              'id': doc.id, // Firebase document ID
            };
          }).toList();

          // Log route statistics for debugging
          final Map<String, int> busRouteCount = {};
          int totalStops = 0;

          for (final route in routes) {
            final busId = route['bus_id'] as String? ?? 'unknown';
            busRouteCount[busId] = (busRouteCount[busId] ?? 0) + 1;
            totalStops += (route['total_stops'] as int? ?? 0);
          }

          final avgStopsPerRoute = routes.isNotEmpty
              ? (totalStops / routes.length).round()
              : 0;

          logInfo(
            '📊 Route Stats - Total: ${routes.length}, Unique Buses: ${busRouteCount.keys.length}, Avg Stops: $avgStopsPerRoute',
          );

          return routes;
        }) ??
        [];
  }

  Stream<List<AppSettingsModel>> getAppSettingsStream() {
    return _fireStore.collection(settingsCollection).snapshots().map((
      snapshot,
    ) {
      return catchAndReturn(() {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return AppSettingsModel.fromJson(data);
            }).toList();
          }) ??
          <AppSettingsModel>[];
    });
  }
}

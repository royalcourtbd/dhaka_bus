import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// 1. Get all buses - IMPROVED
  Future<List<Map<String, dynamic>>> getAllBuses() async {
    // ✅ Explicit generic type + direct return
    return await catchAndReturnFuture<List<Map<String, dynamic>>>(() async {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await _fireStore.collection(busesCollection).get();

          return querySnapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        }) ??
        [];
  }

  /// 2. Get bus by ID - ALREADY PERFECT ✅
  Future<Map<String, dynamic>?> getBusById(String busId) async {
    return await catchAndReturnFuture<Map<String, dynamic>?>(() async {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _fireStore.collection(busesCollection).doc(busId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return {...docSnapshot.data()!, 'id': docSnapshot.id};
      }
      return null;
    });
  }

  /// 3. Search bus by name - IMPROVED
  Future<List<Map<String, dynamic>>> searchBusByName(String searchQuery) async {
    // ✅ Input validation + explicit generic type
    if (searchQuery.trim().isEmpty) return [];

    return await catchAndReturnFuture<List<Map<String, dynamic>>>(() async {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await _fireStore
                  .collection(busesCollection)
                  .where('is_active', isEqualTo: true)
                  .get();

          final allBuses = querySnapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();

          // Filter by name (English or Bengali)
          return allBuses.where((bus) {
            final busNameEn = (bus['bus_name_en'] as String? ?? '')
                .toLowerCase();
            final busNameBn = bus['bus_name_bn'] as String? ?? '';
            final query = searchQuery.toLowerCase();

            return busNameEn.contains(query) || busNameBn.contains(searchQuery);
          }).toList();
        }) ??
        [];
  }

  /// 4. Get active buses - IMPROVED
  Future<List<Map<String, dynamic>>> getActiveBuses() async {
    return await catchAndReturnFuture<List<Map<String, dynamic>>>(() async {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await _fireStore
                  .collection(busesCollection)
                  .where('is_active', isEqualTo: true)
                  .get();

          return querySnapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        }) ??
        [];
  }

  /// 5. Get buses by service type - IMPROVED
  Future<List<Map<String, dynamic>>> getBusesByServiceType(
    String serviceType,
  ) async {
    // ✅ Input validation
    if (serviceType.trim().isEmpty) return [];

    return await catchAndReturnFuture<List<Map<String, dynamic>>>(() async {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              await _fireStore
                  .collection(busesCollection)
                  .where('service_type', isEqualTo: serviceType)
                  .where('is_active', isEqualTo: true)
                  .get();

          return querySnapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        }) ??
        [];
  }
}

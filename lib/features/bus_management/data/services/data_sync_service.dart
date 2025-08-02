// File: bus_management/data/services/data_sync_service.dart

import 'package:dhaka_bus/core/services/connectivity_service.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';
import 'package:dhaka_bus/core/utility/utility_export.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';

class DataSyncService {
  final BusRemoteDataSource _busRemoteDataSource;
  final RouteRemoteDataSource _routeRemoteDataSource;
  final BusLocalDataSource _busLocalDataSource;
  final RouteLocalDataSource _routeLocalDataSource;

  DataSyncService(
    this._busRemoteDataSource,
    this._routeRemoteDataSource,
    this._busLocalDataSource,
    this._routeLocalDataSource,
  );

  /// Check if internet connection is available
  Future<bool> isInternetAvailable() async {
    return await checkInternetConnection();
  }

  /// Load buses - First from cache, then sync if internet available
  Future<List<BusEntity>> loadBuses({bool forceSync = false}) async {
    final DateTime? lastBusSync = await _busLocalDataSource
        .getLastBusSyncTime();
    final bool isFirstTimeLoad = lastBusSync == null;

    logInfo(
      '🚌 DataSyncService: Loading buses... (forceSync: $forceSync, isFirstTime: $isFirstTimeLoad)',
    );

    if (isFirstTimeLoad) {
      logInfo(
        '🆕 FIRST TIME LOAD: No previous bus data found in local storage',
      );
    } else {
      logInfo(
        '🔄 SUBSEQUENT LOAD: Last sync was at ${lastBusSync.toIso8601String()}',
      );
    }

    // Always try to load from cache first (instant loading)
    List<BusEntity> cachedBuses = await _busLocalDataSource.getCachedBuses();
    logInfo(
      '📱 DataSyncService: Loaded ${cachedBuses.length} buses from LOCAL STORAGE (Hive)',
    );

    // If no cached data and no internet, return empty list
    final bool hasInternet = await isInternetAvailable();
    if (cachedBuses.isEmpty && !hasInternet) {
      logWarning('🚌 No cached buses and no internet connection');
      return [];
    }

    // If we have cached data and don't need to force sync, return cached data
    // But still sync in background if internet is available
    if (cachedBuses.isNotEmpty && !forceSync && hasInternet) {
      if (isFirstTimeLoad) {
        logInfo(
          '🚌 ✅ DATA SOURCE: LOCAL STORAGE (Hive) - FIRST TIME using ${cachedBuses.length} cached buses',
        );
      } else {
        logInfo(
          '🚌 ✅ DATA SOURCE: LOCAL STORAGE (Hive) - SUBSEQUENT load with ${cachedBuses.length} cached buses',
        );
      }
      logInfo('🚌 Background sync from Firebase will run in background...');
      _syncBusesInBackground();
      return cachedBuses;
    }

    // If we need fresh data or no cached data, fetch from remote
    if (hasInternet) {
      if (isFirstTimeLoad) {
        logInfo(
          '🔄 DataSyncService: FIRST TIME fetching buses from FIREBASE (Remote)...',
        );
      } else {
        logInfo(
          '🔄 DataSyncService: FORCE SYNC fetching buses from FIREBASE (Remote)...',
        );
      }
      final List<BusEntity> remoteBuses = await _fetchBusesFromRemote();
      if (remoteBuses.isNotEmpty) {
        if (isFirstTimeLoad) {
          logInfo(
            '🔥 DataSyncService: ✅ DATA SOURCE: FIREBASE - FIRST TIME loaded ${remoteBuses.length} buses',
          );
        } else {
          logInfo(
            '🔥 DataSyncService: ✅ DATA SOURCE: FIREBASE - FORCE SYNC loaded ${remoteBuses.length} buses',
          );
        }
        await _busLocalDataSource.cacheBuses(remoteBuses);
        await _busLocalDataSource.updateLastBusSyncTime();
        logInfo(
          '🚌 Buses synced from Firebase and cached to Hive successfully',
        );
        return remoteBuses;
      }
    }

    // Fallback to cached data if available
    logInfo(
      '🚌 ⚠️ FALLBACK: Using LOCAL STORAGE (Hive) - ${cachedBuses.length} buses',
    );
    return cachedBuses;
  }

  /// Load routes - First from cache, then sync if internet available
  Future<List<RouteEntity>> loadRoutes({bool forceSync = false}) async {
    final DateTime? lastRouteSync = await _routeLocalDataSource
        .getLastRouteSyncTime();
    final bool isFirstTimeLoad = lastRouteSync == null;

    logInfo(
      '🛣️ DataSyncService: Loading routes... (forceSync: $forceSync, isFirstTime: $isFirstTimeLoad)',
    );

    if (isFirstTimeLoad) {
      logInfo(
        '🆕 FIRST TIME LOAD: No previous route data found in local storage',
      );
    } else {
      logInfo(
        '🔄 SUBSEQUENT LOAD: Last sync was at ${lastRouteSync.toIso8601String()}',
      );
    }

    // Always try to load from cache first (instant loading)
    List<RouteEntity> cachedRoutes = await _routeLocalDataSource
        .getCachedRoutes();
    logInfo(
      '📱 DataSyncService: Loaded ${cachedRoutes.length} routes from LOCAL STORAGE (Hive)',
    );

    // If no cached data and no internet, return empty list
    final bool hasInternet = await isInternetAvailable();
    if (cachedRoutes.isEmpty && !hasInternet) {
      logWarning('🛣️ No cached routes and no internet connection');
      return [];
    }

    // If we have cached data and don't need to force sync, return cached data
    // But still sync in background if internet is available
    if (cachedRoutes.isNotEmpty && !forceSync && hasInternet) {
      if (isFirstTimeLoad) {
        logInfo(
          '🛣️ ✅ DATA SOURCE: LOCAL STORAGE (Hive) - FIRST TIME using ${cachedRoutes.length} cached routes',
        );
      } else {
        logInfo(
          '🛣️ ✅ DATA SOURCE: LOCAL STORAGE (Hive) - SUBSEQUENT load with ${cachedRoutes.length} cached routes',
        );
      }
      logInfo('🛣️ Background sync from Firebase will run in background...');
      _syncRoutesInBackground();
      return cachedRoutes;
    }

    // If we need fresh data or no cached data, fetch from remote
    if (hasInternet) {
      if (isFirstTimeLoad) {
        logInfo(
          '🔄 DataSyncService: FIRST TIME fetching routes from FIREBASE (Remote)...',
        );
      } else {
        logInfo(
          '🔄 DataSyncService: FORCE SYNC fetching routes from FIREBASE (Remote)...',
        );
      }
      final List<RouteEntity> remoteRoutes = await _fetchRoutesFromRemote();
      if (remoteRoutes.isNotEmpty) {
        if (isFirstTimeLoad) {
          logInfo(
            '🔥 DataSyncService: ✅ DATA SOURCE: FIREBASE - FIRST TIME loaded ${remoteRoutes.length} routes',
          );
        } else {
          logInfo(
            '🔥 DataSyncService: ✅ DATA SOURCE: FIREBASE - FORCE SYNC loaded ${remoteRoutes.length} routes',
          );
        }
        await _routeLocalDataSource.cacheRoutes(remoteRoutes);
        await _routeLocalDataSource.updateLastRouteSyncTime();
        logInfo(
          '🛣️ Routes synced from Firebase and cached to Hive successfully',
        );
        return remoteRoutes;
      }
    }

    // Fallback to cached data if available
    logInfo(
      '🛣️ ⚠️ FALLBACK: Using LOCAL STORAGE (Hive) - ${cachedRoutes.length} routes',
    );
    return cachedRoutes;
  }

  /// Get routes for specific bus ID from cache
  Future<List<RouteEntity>> getRoutesByBusId(String busId) async {
    logInfo(
      '🛣️ DataSyncService: Loading routes for busId: $busId from LOCAL STORAGE (Hive)',
    );
    final routes = await _routeLocalDataSource.getCachedRoutesByBusId(busId);
    logInfo(
      '📱 DataSyncService: ✅ DATA SOURCE: LOCAL STORAGE (Hive) - Found ${routes.length} routes for bus: $busId',
    );
    return routes;
  }

  /// Force sync all data
  Future<bool> forceSyncAllData() async {
    logInfo('🔄 DataSyncService: Force syncing all data...');

    if (!await isInternetAvailable()) {
      logWarning('🔄 Cannot sync - no internet connection');
      return false;
    }

    bool busesSuccess = false;
    bool routesSuccess = false;

    // Sync buses
    final List<BusEntity> remoteBuses = await _fetchBusesFromRemote();
    if (remoteBuses.isNotEmpty) {
      await _busLocalDataSource.cacheBuses(remoteBuses);
      await _busLocalDataSource.updateLastBusSyncTime();
      busesSuccess = true;
      logInfo('🚌 Buses force synced successfully');
    }

    // Sync routes
    final List<RouteEntity> remoteRoutes = await _fetchRoutesFromRemote();
    if (remoteRoutes.isNotEmpty) {
      await _routeLocalDataSource.cacheRoutes(remoteRoutes);
      await _routeLocalDataSource.updateLastRouteSyncTime();
      routesSuccess = true;
      logInfo('🛣️ Routes force synced successfully');
    }

    final bool overallSuccess = busesSuccess && routesSuccess;
    logInfo('🔄 Force sync completed. Success: $overallSuccess');

    return overallSuccess;
  }

  /// Background sync for buses
  Future<void> _syncBusesInBackground() async {
    catchFutureOrVoid(() async {
      logInfo('🚌 🔄 Background syncing buses from FIREBASE...');
      final List<BusEntity> remoteBuses = await _fetchBusesFromRemote();
      if (remoteBuses.isNotEmpty) {
        logInfo(
          '🔥 Background sync: ✅ DATA SOURCE: FIREBASE - Fetched ${remoteBuses.length} buses',
        );
        await _busLocalDataSource.cacheBuses(remoteBuses);
        await _busLocalDataSource.updateLastBusSyncTime();
        logInfo('🚌 Background bus sync completed - Cached to Hive');
      } else {
        logWarning('🚌 Background sync: ⚠️ No buses fetched from Firebase');
      }
    });
  }

  /// Background sync for routes
  Future<void> _syncRoutesInBackground() async {
    catchFutureOrVoid(() async {
      logInfo('🛣️ 🔄 Background syncing routes from FIREBASE...');
      final List<RouteEntity> remoteRoutes = await _fetchRoutesFromRemote();
      if (remoteRoutes.isNotEmpty) {
        logInfo(
          '🔥 Background sync: ✅ DATA SOURCE: FIREBASE - Fetched ${remoteRoutes.length} routes',
        );
        await _routeLocalDataSource.cacheRoutes(remoteRoutes);
        await _routeLocalDataSource.updateLastRouteSyncTime();
        logInfo('🛣️ Background route sync completed - Cached to Hive');
      } else {
        logWarning('🛣️ Background sync: ⚠️ No routes fetched from Firebase');
      }
    });
  }

  /// Fetch buses from remote source
  Future<List<BusEntity>> _fetchBusesFromRemote() async {
    return await catchAndReturnFuture<List<BusEntity>>(() async {
          final List<Map<String, dynamic>> busesData =
              await _busRemoteDataSource.getAllActiveBuses();

          final List<BusEntity> buses = busesData
              .map((Map<String, dynamic> busData) => _mapToBusEntity(busData))
              .toList();

          return buses;
        }) ??
        <BusEntity>[];
  }

  /// Fetch routes from remote source
  Future<List<RouteEntity>> _fetchRoutesFromRemote() async {
    return await catchAndReturnFuture<List<RouteEntity>>(() async {
          final List<Map<String, dynamic>> routesData =
              await _routeRemoteDataSource.getAllRoutes();

          final List<RouteEntity> routes = routesData
              .map(
                (Map<String, dynamic> routeData) =>
                    _mapToRouteEntity(routeData),
              )
              .toList();

          return routes;
        }) ??
        <RouteEntity>[];
  }

  /// Helper method to map bus data to entity
  BusEntity _mapToBusEntity(Map<String, dynamic> busData) {
    final Map<String, dynamic> mappedData = Map<String, dynamic>.from(busData);

    if (mappedData.containsKey('id') && !mappedData.containsKey('bus_id')) {
      mappedData['bus_id'] = mappedData['id'];
    }

    return BusModel.fromJson(mappedData);
  }

  /// Helper method to map route data to entity
  RouteEntity _mapToRouteEntity(Map<String, dynamic> routeData) {
    final Map<String, dynamic> mappedData = Map<String, dynamic>.from(
      routeData,
    );

    if (mappedData.containsKey('id') && !mappedData.containsKey('route_id')) {
      mappedData['route_id'] = mappedData['id'];
    }

    return RouteModel.fromJson(mappedData);
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    await catchFutureOrVoid(() async {
      await _busLocalDataSource.clearBusCache();
      await _routeLocalDataSource.clearRouteCache();
      logInfo('🗑️ All cache cleared');
    });
  }

  /// Get sync status information
  Future<Map<String, dynamic>> getSyncStatus() async {
    return await catchAndReturnFuture<Map<String, dynamic>>(() async {
          final DateTime? lastBusSync = await _busLocalDataSource
              .getLastBusSyncTime();
          final DateTime? lastRouteSync = await _routeLocalDataSource
              .getLastRouteSyncTime();
          final bool hasInternet = await isInternetAvailable();

          return {
            'hasInternet': hasInternet,
            'lastBusSync': lastBusSync?.toIso8601String(),
            'lastRouteSync': lastRouteSync?.toIso8601String(),
            'needsSync': lastBusSync == null || lastRouteSync == null,
          };
        }) ??
        {};
  }
}

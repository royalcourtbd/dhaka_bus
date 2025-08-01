// File: bus_management/data/datasource/route_local_datasource.dart

import 'dart:convert';
import 'package:dhaka_bus/core/services/local_cache_service.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';

abstract class RouteLocalDataSource {
  Future<List<RouteEntity>> getCachedRoutes();
  Future<void> cacheRoutes(List<RouteEntity> routes);
  Future<void> clearRouteCache();
  Future<DateTime?> getLastRouteSyncTime();
  Future<void> updateLastRouteSyncTime();
  Future<List<RouteEntity>> getCachedRoutesByBusId(String busId);
}

class RouteLocalDataSourceImpl implements RouteLocalDataSource {
  final LocalCacheService _localCacheService;

  RouteLocalDataSourceImpl(this._localCacheService);

  @override
  Future<List<RouteEntity>> getCachedRoutes() async {
    return await catchAndReturnFuture<List<RouteEntity>>(() async {
          final String? jsonString = _localCacheService.getData<String>(
            key: CacheKeys.allRoutes,
          );

          if (jsonString == null || jsonString.isEmpty) {
            return <RouteEntity>[];
          }

          final List<dynamic> jsonList = jsonDecode(jsonString);
          final List<RouteEntity> routes = jsonList
              .map((json) => RouteModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return routes;
        }) ??
        <RouteEntity>[];
  }

  @override
  Future<void> cacheRoutes(List<RouteEntity> routes) async {
    await catchFutureOrVoid(() async {
      final List<Map<String, dynamic>> routeJsonList = routes
          .map((route) => RouteModelExtension.fromEntity(route).toJson())
          .toList();

      final String jsonString = jsonEncode(routeJsonList);

      await _localCacheService.saveData<String>(
        key: CacheKeys.allRoutes,
        value: jsonString,
      );
    });
  }

  @override
  Future<void> clearRouteCache() async {
    await catchFutureOrVoid(() async {
      await _localCacheService.deleteData(key: CacheKeys.allRoutes);
    });
  }

  @override
  Future<DateTime?> getLastRouteSyncTime() async {
    return catchAndReturn<DateTime?>(() {
      final String? timeString = _localCacheService.getData<String>(
        key: CacheKeys.lastRouteSync,
      );

      if (timeString == null) return null;

      return DateTime.parse(timeString);
    });
  }

  @override
  Future<void> updateLastRouteSyncTime() async {
    await catchFutureOrVoid(() async {
      final String currentTime = DateTime.now().toIso8601String();
      await _localCacheService.saveData<String>(
        key: CacheKeys.lastRouteSync,
        value: currentTime,
      );
    });
  }

  @override
  Future<List<RouteEntity>> getCachedRoutesByBusId(String busId) async {
    return await catchAndReturnFuture<List<RouteEntity>>(() async {
          if (busId.trim().isEmpty) {
            return <RouteEntity>[];
          }

          final List<RouteEntity> allRoutes = await getCachedRoutes();

          // Filter routes by bus_id
          final List<RouteEntity> filteredRoutes = allRoutes
              .where((route) => route.busId == busId)
              .toList();

          return filteredRoutes;
        }) ??
        <RouteEntity>[];
  }
}

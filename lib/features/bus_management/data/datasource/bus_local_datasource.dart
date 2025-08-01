// File: bus_management/data/datasource/bus_local_datasource.dart

import 'dart:convert';
import 'package:dhaka_bus/core/services/local_cache_service.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';
import 'package:dhaka_bus/features/bus_management/data/models/bus_model.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';

abstract class BusLocalDataSource {
  Future<List<BusEntity>> getCachedBuses();
  Future<void> cacheBuses(List<BusEntity> buses);
  Future<void> clearBusCache();
  Future<DateTime?> getLastBusSyncTime();
  Future<void> updateLastBusSyncTime();
}

class BusLocalDataSourceImpl implements BusLocalDataSource {
  final LocalCacheService _localCacheService;

  BusLocalDataSourceImpl(this._localCacheService);

  @override
  Future<List<BusEntity>> getCachedBuses() async {
    return await catchAndReturnFuture<List<BusEntity>>(() async {
          final String? jsonString = _localCacheService.getData<String>(
            key: CacheKeys.allBuses,
          );

          if (jsonString == null || jsonString.isEmpty) {
            return <BusEntity>[];
          }

          final List<dynamic> jsonList = jsonDecode(jsonString);
          final List<BusEntity> buses = jsonList
              .map((json) => BusModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return buses;
        }) ??
        <BusEntity>[];
  }

  @override
  Future<void> cacheBuses(List<BusEntity> buses) async {
    await catchFutureOrVoid(() async {
      final List<Map<String, dynamic>> busJsonList = buses
          .map((bus) => BusModelExtension.fromEntity(bus).toJson())
          .toList();

      final String jsonString = jsonEncode(busJsonList);

      await _localCacheService.saveData<String>(
        key: CacheKeys.allBuses,
        value: jsonString,
      );
    });
  }

  @override
  Future<void> clearBusCache() async {
    await catchFutureOrVoid(() async {
      await _localCacheService.deleteData(key: CacheKeys.allBuses);
    });
  }

  @override
  Future<DateTime?> getLastBusSyncTime() async {
    return catchAndReturn<DateTime?>(() {
      final String? timeString = _localCacheService.getData<String>(
        key: CacheKeys.lastBusSync,
      );

      if (timeString == null) return null;

      return DateTime.parse(timeString);
    });
  }

  @override
  Future<void> updateLastBusSyncTime() async {
    await catchFutureOrVoid(() async {
      final String currentTime = DateTime.now().toIso8601String();
      await _localCacheService.saveData<String>(
        key: CacheKeys.lastBusSync,
        value: currentTime,
      );
    });
  }
}

// BusModel এ fromEntity method add করতে হবে
extension BusModelExtension on BusModel {
  static BusModel fromEntity(BusEntity entity) {
    return BusModel(
      busId: entity.busId,
      busNameEn: entity.busNameEn,
      busNameBn: entity.busNameBn,
      busImageUrl: entity.busImageUrl,
      serviceType: entity.serviceType,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}

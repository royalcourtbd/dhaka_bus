// lib/domain/repositories/bus_repository.dart

import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class BusRepository {
  Future<Either<String, List<BusEntity>>> getAllBuses();

  Future<Either<String, BusEntity?>> getBusById(String busId);

  Future<Either<String, List<BusEntity>>> searchBusByName(String searchQuery);

  Future<Either<String, List<BusEntity>>> getActiveBuses();

  Future<Either<String, List<BusEntity>>> getBusesByServiceType(
    String serviceType,
  );
}

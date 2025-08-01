// lib/domain/repositories/bus_repository.dart

import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:fpdart/fpdart.dart';

abstract class BusRepository {
  Future<Either<String, List<BusEntity>>> getAllActiveBuses({
    bool forceSync = false,
  });
}

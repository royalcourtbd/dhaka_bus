import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class RouteRepository {
  Future<Either<String, List<RouteEntity>>> getAllRoutes({
    bool forceSync = false,
  });
  Future<Either<String, List<RouteEntity>>> getRoutesByBusId(String busId);
}

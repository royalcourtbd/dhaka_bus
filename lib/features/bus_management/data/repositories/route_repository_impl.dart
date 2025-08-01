import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/data/datasource/route_remote_datasource.dart';
import 'package:dhaka_bus/features/bus_management/data/models/route_model.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/route_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource _routeRemoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  RouteRepositoryImpl(this._routeRemoteDataSource, this._errorMessageHandler);

  @override
  Future<Either<String, List<RouteEntity>>> getAllRoutes() async {
    final Either<String, List<RouteEntity>>? result =
        await catchAndReturnFuture<Either<String, List<RouteEntity>>>(() async {
          final List<Map<String, dynamic>> routesData =
              await _routeRemoteDataSource.getAllRoutes();

          final List<RouteEntity> routes = routesData
              .map(
                (Map<String, dynamic> routeData) =>
                    _mapToRouteEntity(routeData),
              )
              .toList();

          return right<String, List<RouteEntity>>(routes);
        });

    if (result != null) {
      return result;
    } else {
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        'Unknown error occurred while getting all routes',
      );
      return left<String, List<RouteEntity>>(errorMessage);
    }
  }

  @override
  Future<Either<String, List<RouteEntity>>> getRoutesByBusId(
    String busId,
  ) async {
    final Either<String, List<RouteEntity>>? result =
        await catchAndReturnFuture<Either<String, List<RouteEntity>>>(() async {
          if (busId.trim().isEmpty) {
            return right<String, List<RouteEntity>>([]);
          }

          final List<Map<String, dynamic>> routesData =
              await _routeRemoteDataSource.getRoutesByBusId(busId);

          final List<RouteEntity> routes = routesData
              .map(
                (Map<String, dynamic> routeData) =>
                    _mapToRouteEntity(routeData),
              )
              .toList();

          return right<String, List<RouteEntity>>(routes);
        });

    if (result != null) {
      return result;
    } else {
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        'Unknown error occurred while getting routes for bus ($busId)',
      );
      return left<String, List<RouteEntity>>(errorMessage);
    }
  }

  /// Helper method to convert Map data to RouteEntity
  /// Handles the mapping between backend 'id' field and model 'route_id' field
  RouteEntity _mapToRouteEntity(Map<String, dynamic> routeData) {
    // Backend service adds 'id' field, but our model expects 'route_id'
    // So we need to map 'id' -> 'route_id' if needed
    final Map<String, dynamic> mappedData = Map<String, dynamic>.from(
      routeData,
    );

    // If 'id' exists but 'route_id' doesn't, map it
    if (mappedData.containsKey('id') && !mappedData.containsKey('route_id')) {
      mappedData['route_id'] = mappedData['id'];
    }

    // Create RouteModel from JSON and return as RouteEntity
    final RouteModel routeModel = RouteModel.fromJson(mappedData);
    return routeModel; // RouteModel extends RouteEntity, so implicit conversion
  }
}

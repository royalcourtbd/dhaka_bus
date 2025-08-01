import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/data/services/data_sync_service.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/route_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';

class RouteRepositoryImpl implements RouteRepository {
  final DataSyncService _dataSyncService;
  final ErrorMessageHandler _errorMessageHandler;

  RouteRepositoryImpl(this._dataSyncService, this._errorMessageHandler);

  @override
  Future<Either<String, List<RouteEntity>>> getAllRoutes({
    bool forceSync = false,
  }) async {
    final Either<String, List<RouteEntity>>? result =
        await catchAndReturnFuture<Either<String, List<RouteEntity>>>(() async {
          final List<RouteEntity> routes = await _dataSyncService.loadRoutes(
            forceSync: forceSync,
          );

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

          final List<RouteEntity> routes = await _dataSyncService
              .getRoutesByBusId(busId);

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
}

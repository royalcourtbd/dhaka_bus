import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/route_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/base/base_use_case.dart';

class GetRoutesByBusIdUseCase extends BaseUseCase<List<RouteEntity>> {
  final RouteRepository _routeRepository;

  GetRoutesByBusIdUseCase(
    this._routeRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, List<RouteEntity>>> execute(String busId) async {
    return await _routeRepository.getRoutesByBusId(busId);
  }
}

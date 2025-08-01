import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/base/base_use_case.dart';

class GetRoutesUseCase extends BaseUseCase<List<RouteEntity>> {
  final RouteRepository _routeRepository;

  GetRoutesUseCase(
    this._routeRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, List<RouteEntity>>> execute({
    bool forceSync = false,
  }) async {
    return await _routeRepository.getAllRoutes(forceSync: forceSync);
  }
}

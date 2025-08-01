import 'package:dhaka_bus/core/services/backend_as_a_service.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';

abstract class RouteRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllRoutes();
  Future<List<Map<String, dynamic>>> getRoutesByBusId(String busId);
}

class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final BackendAsAService _backendAsAService;

  RouteRemoteDataSourceImpl(this._backendAsAService);

  @override
  Future<List<Map<String, dynamic>>> getAllRoutes() async {
    return await catchAndReturnFuture(() async {
          final List<Map<String, dynamic>> result = await _backendAsAService
              .getAllRoutes();
          return result;
        }) ??
        [];
  }

  @override
  Future<List<Map<String, dynamic>>> getRoutesByBusId(String busId) async {
    return await catchAndReturnFuture(() async {
          if (busId.trim().isEmpty) {
            return <Map<String, dynamic>>[];
          }

          final List<Map<String, dynamic>> allRoutes = await _backendAsAService
              .getAllRoutes();

          // Filter routes by bus_id
          final List<Map<String, dynamic>> filteredRoutes = allRoutes
              .where((route) => route['bus_id'] == busId)
              .toList();

          return filteredRoutes;
        }) ??
        [];
  }
}

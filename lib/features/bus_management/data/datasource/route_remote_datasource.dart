import 'package:dhaka_bus/core/services/backend_as_a_service.dart';

abstract class RouteRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllRoutes();
  Future<List<Map<String, dynamic>>> getRoutesByBusId(String busId);
}

class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final BackendAsAService _backendAsAService;

  RouteRemoteDataSourceImpl(this._backendAsAService);

  @override
  Future<List<Map<String, dynamic>>> getAllRoutes() async {
    try {
      final result = await _backendAsAService.getAllRoutes();
      return result;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRoutesByBusId(String busId) async {
    try {
      if (busId.trim().isEmpty) {
        return [];
      }

      final allRoutes = await _backendAsAService.getAllRoutes();

      // Filter routes by bus_id
      final filteredRoutes = allRoutes
          .where((route) => route['bus_id'] == busId)
          .toList();

      return filteredRoutes;
    } catch (error) {
      rethrow;
    }
  }
}

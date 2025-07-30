import 'package:dhaka_bus/core/services/backend_as_a_service.dart';

abstract class BusRemoteDataSource {
  Future<List<Map<String, dynamic>>> getBuses();
  Future<Map<String, dynamic>?> getBusById(String busId);
  Future<List<Map<String, dynamic>>> searchBusByName(String searchQuery);
  Future<List<Map<String, dynamic>>> getBusesByServiceType(String serviceType);
}

class BusRemoteDataSourceImpl implements BusRemoteDataSource {
  final BackendAsAService _backendAsAService;

  BusRemoteDataSourceImpl(this._backendAsAService);

  @override
  Future<List<Map<String, dynamic>>> getBuses() async {
    try {
      final result = await _backendAsAService.getBuses();
      return result;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getBusById(String busId) async {
    try {
      final result = await _backendAsAService.getBusById(busId);
      return result;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchBusByName(String searchQuery) async {
    try {
      if (searchQuery.trim().isEmpty) {
        return [];
      }
      final result = await _backendAsAService.searchBusByName(searchQuery);
      return result;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getBusesByServiceType(
    String serviceType,
  ) async {
    try {
      if (serviceType.trim().isEmpty) {
        return [];
      }

      final result = await _backendAsAService.getBusesByServiceType(
        serviceType,
      );

      return result;
    } catch (error) {
      rethrow;
    }
  }
}

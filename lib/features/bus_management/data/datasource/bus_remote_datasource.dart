import 'package:dhaka_bus/core/services/backend_as_a_service.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';

abstract class BusRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllBuses();
  Future<Map<String, dynamic>?> getBusById(String busId);
  Future<List<Map<String, dynamic>>> searchBusByName(String searchQuery);
  Future<List<Map<String, dynamic>>> getActiveBuses();
  Future<List<Map<String, dynamic>>> getBusesByServiceType(String serviceType);
}

class BusRemoteDataSourceImpl implements BusRemoteDataSource {
  final BackendAsAService _backendAsAService;

  BusRemoteDataSourceImpl(this._backendAsAService);

  @override
  Future<List<Map<String, dynamic>>> getAllBuses() async {
    try {
      logDebug('Fetching all buses from remote');
      final result = await _backendAsAService.getAllBuses();
      logDebug('Successfully fetched ${result.length} buses');
      return result;
    } catch (error) {
      logError('Error fetching all buses: $error');
      rethrow; // Repository layer এ handle করবে
    }
  }

  @override
  Future<Map<String, dynamic>?> getBusById(String busId) async {
    try {
      logDebug('Fetching bus with ID: $busId');
      final result = await _backendAsAService.getBusById(busId);

      if (result != null) {
        logDebug(
          'Successfully fetched bus: ${result['bus_name_en'] ?? 'Unknown'}',
        );
      } else {
        logDebug('No bus found with ID: $busId');
      }

      return result;
    } catch (error) {
      logError('Error fetching bus by ID ($busId): $error');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchBusByName(String searchQuery) async {
    try {
      if (searchQuery.trim().isEmpty) {
        logDebug('Empty search query provided');
        return [];
      }

      logDebug('Searching buses with query: $searchQuery');
      final result = await _backendAsAService.searchBusByName(searchQuery);
      logDebug('Found ${result.length} buses matching: $searchQuery');
      return result;
    } catch (error) {
      logError('Error searching buses with query ($searchQuery): $error');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveBuses() async {
    try {
      logDebug('Fetching active buses from remote');
      final result = await _backendAsAService.getActiveBuses();
      logDebug('Successfully fetched ${result.length} active buses');
      return result;
    } catch (error) {
      logError('Error fetching active buses: $error');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getBusesByServiceType(
    String serviceType,
  ) async {
    try {
      if (serviceType.trim().isEmpty) {
        logDebug('Empty service type provided');
        return [];
      }

      logDebug('Fetching buses for service type: $serviceType');
      final result = await _backendAsAService.getBusesByServiceType(
        serviceType,
      );
      logDebug('Found ${result.length} buses for service type: $serviceType');
      return result;
    } catch (error) {
      logError('Error fetching buses by service type ($serviceType): $error');
      rethrow;
    }
  }
}

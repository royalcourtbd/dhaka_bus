import 'package:dhaka_bus/core/services/backend_as_a_service.dart';

abstract class BusRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllActiveBuses();
}

class BusRemoteDataSourceImpl implements BusRemoteDataSource {
  final BackendAsAService _backendAsAService;

  BusRemoteDataSourceImpl(this._backendAsAService);

  @override
  Future<List<Map<String, dynamic>>> getAllActiveBuses() async {
    try {
      final result = await _backendAsAService.getAllActiveBuses();
      return result;
    } catch (error) {
      rethrow;
    }
  }
}

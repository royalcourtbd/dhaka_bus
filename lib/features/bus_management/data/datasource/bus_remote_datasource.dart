import 'package:dhaka_bus/core/services/backend_as_a_service.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';

abstract class BusRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllActiveBuses();
}

class BusRemoteDataSourceImpl implements BusRemoteDataSource {
  final BackendAsAService _backendAsAService;

  BusRemoteDataSourceImpl(this._backendAsAService);

  @override
  Future<List<Map<String, dynamic>>> getAllActiveBuses() async {
    return await catchAndReturnFuture(() async {
          final List<Map<String, dynamic>> result = await _backendAsAService
              .getAllActiveBuses();
          return result;
        }) ??
        [];
  }
}

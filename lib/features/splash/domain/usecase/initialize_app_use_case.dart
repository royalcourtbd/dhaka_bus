import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/bus_management/data/services/data_sync_service.dart';

class InitializeAppUseCase extends BaseUseCase<bool> {
  InitializeAppUseCase(super.errorMessageHandler, this._dataSyncService);

  final DataSyncService _dataSyncService;

  Future<Either<String, bool>> execute() => mapResultToEither(() async {
    await _dataSyncService.loadBuses(forceSync: false);

    await _dataSyncService.loadRoutes(forceSync: false);

    return true;
  });
}

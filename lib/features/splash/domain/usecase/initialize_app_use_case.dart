import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/bus_management/data/services/data_sync_service.dart';

class InitializeAppUseCase extends BaseUseCase<bool> {
  InitializeAppUseCase(super.errorMessageHandler, this._dataSyncService);

  final DataSyncService _dataSyncService;

  Future<Either<String, bool>> execute() => mapResultToEither(() async {
    logInfo('🚀 InitializeAppUseCase: Starting app initialization...');

    // Initialize and sync bus data in background
    logInfo('📊 Starting bus data synchronization...');
    await _dataSyncService.loadBuses(forceSync: false);

    // Initialize and sync route data in background
    logInfo('🛣️ Starting route data synchronization...');
    await _dataSyncService.loadRoutes(forceSync: false);

    logInfo(
      '✅ InitializeAppUseCase: App initialization completed successfully',
    );
    return true;
  });
}

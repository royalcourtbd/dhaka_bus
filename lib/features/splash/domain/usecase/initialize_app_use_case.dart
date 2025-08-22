import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/bus_management/data/services/data_sync_service.dart';

class InitializeAppUseCase extends BaseUseCase<bool> {
  InitializeAppUseCase(super.errorMessageHandler, this._dataSyncService);

  final DataSyncService _dataSyncService;

  Future<Either<String, bool>> execute() => mapResultToEither(() async {
    logInfo('🚀 InitializeAppUseCase: Starting app initialization...');
    logInfo('💾 Pre-loading and caching data for fast app startup');

    // Initialize and sync bus data - this will cache data for instant access
    logInfo('📊 Pre-loading bus data to cache...');
    await _dataSyncService.loadBuses(forceSync: false);

    // Initialize and sync route data - this will cache data for instant access
    logInfo('🛣️ Pre-loading route data to cache...');
    await _dataSyncService.loadRoutes(forceSync: false);

    logInfo(
      '✅ InitializeAppUseCase: App initialization completed - Data cached for instant access',
    );
    return true;
  });
}

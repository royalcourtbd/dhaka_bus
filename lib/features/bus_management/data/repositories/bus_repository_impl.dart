import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/data/services/data_sync_service.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';

class BusRepositoryImpl implements BusRepository {
  final DataSyncService _dataSyncService;
  final ErrorMessageHandler _errorMessageHandler;

  BusRepositoryImpl(this._dataSyncService, this._errorMessageHandler);

  @override
  Future<Either<String, List<BusEntity>>> getAllActiveBuses({
    bool forceSync = false,
  }) async {
    final Either<String, List<BusEntity>>? result =
        await catchAndReturnFuture<Either<String, List<BusEntity>>>(() async {
          final List<BusEntity> buses = await _dataSyncService.loadBuses(
            forceSync: forceSync,
          );

          return right<String, List<BusEntity>>(buses);
        });

    if (result != null) {
      return result;
    } else {
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        'Unknown error occurred while getting all active buses',
      );
      return left<String, List<BusEntity>>(errorMessage);
    }
  }
}

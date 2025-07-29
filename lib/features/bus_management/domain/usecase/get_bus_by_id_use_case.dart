import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/base/base_use_case.dart';

class GetBusByIdUseCase extends BaseUseCase<BusEntity?> {
  final BusRepository _busRepository;

  GetBusByIdUseCase(
    this._busRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, BusEntity?>> execute(String busId) async {
    return await _busRepository.getBusById(busId);
  }
}

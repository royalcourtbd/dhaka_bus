import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/base/base_use_case.dart';

class SearchBusUseCase extends BaseUseCase<List<BusEntity>> {
  final BusRepository _busRepository;

  SearchBusUseCase(this._busRepository, ErrorMessageHandler errorMessageHandler)
    : super(errorMessageHandler);

  Future<Either<String, List<BusEntity>>> execute(String searchQuery) async {
    return await _busRepository.searchBusByName(searchQuery);
  }
}

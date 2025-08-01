// lib/data/repositories/bus_repository_impl.dart

import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/data/datasource/bus_remote_datasource.dart';
import 'package:dhaka_bus/features/bus_management/data/models/bus_model.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/utility/trial_utility.dart';

class BusRepositoryImpl implements BusRepository {
  final BusRemoteDataSource _busRemoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  BusRepositoryImpl(this._busRemoteDataSource, this._errorMessageHandler);

  @override
  Future<Either<String, List<BusEntity>>> getAllActiveBuses() async {
    final Either<String, List<BusEntity>>? result =
        await catchAndReturnFuture<Either<String, List<BusEntity>>>(() async {
          final List<Map<String, dynamic>> busesData =
              await _busRemoteDataSource.getAllActiveBuses();

          final List<BusEntity> buses = busesData
              .map((Map<String, dynamic> busData) => _mapToBusEntity(busData))
              .toList();

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

  /// Helper method to convert Map data to BusEntity
  /// Handles the mapping between backend 'id' field and model 'bus_id' field
  BusEntity _mapToBusEntity(Map<String, dynamic> busData) {
    // Backend service adds 'id' field, but our model expects 'bus_id'
    // So we need to map 'id' -> 'bus_id' if needed
    final Map<String, dynamic> mappedData = Map<String, dynamic>.from(busData);

    // If 'id' exists but 'bus_id' doesn't, map it
    if (mappedData.containsKey('id') && !mappedData.containsKey('bus_id')) {
      mappedData['bus_id'] = mappedData['id'];
    }

    // Create BusModel from JSON and return as BusEntity
    final BusModel busModel = BusModel.fromJson(mappedData);
    return busModel; // BusModel extends BusEntity, so implicit conversion
  }
}

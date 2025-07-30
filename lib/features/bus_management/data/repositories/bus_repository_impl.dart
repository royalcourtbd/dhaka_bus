// lib/data/repositories/bus_repository_impl.dart

import 'package:dhaka_bus/core/services/error_message_handler.dart';
import 'package:dhaka_bus/features/bus_management/data/datasource/bus_remote_datasource.dart';
import 'package:dhaka_bus/features/bus_management/data/models/bus_model.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';
import 'package:dhaka_bus/features/bus_management/domain/repositories/bus_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';

class BusRepositoryImpl implements BusRepository {
  final BusRemoteDataSource _busRemoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  BusRepositoryImpl(this._busRemoteDataSource, this._errorMessageHandler);

  @override
  Future<Either<String, List<BusEntity>>> getBuses({bool? isActive}) async {
    try {
      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .getBuses();

      final List<BusEntity> buses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      return right<String, List<BusEntity>>(buses);
    } catch (error) {
      String errorContext = isActive == null
          ? 'getting all buses'
          : 'getting ${isActive ? "active" : "inactive"} buses';

      logError('BusRepository: Error $errorContext - $error');
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        error,
      );
      return left<String, List<BusEntity>>(errorMessage);
    }
  }

  @override
  Future<Either<String, BusEntity?>> getBusById(String busId) async {
    try {
      if (busId.trim().isEmpty) {
        return right<String, BusEntity?>(null);
      }

      final Map<String, dynamic>? busData = await _busRemoteDataSource
          .getBusById(busId);

      if (busData == null) {
        return right<String, BusEntity?>(null);
      }

      final BusEntity bus = _mapToBusEntity(busData);

      return right<String, BusEntity?>(bus);
    } catch (error) {
      logError('BusRepository: Error getting bus by ID ($busId) - $error');
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        error,
      );
      return left<String, BusEntity?>(errorMessage);
    }
  }

  @override
  Future<Either<String, List<BusEntity>>> searchBusByName(
    String searchQuery,
  ) async {
    try {
      if (searchQuery.trim().isEmpty) {
        return right<String, List<BusEntity>>([]);
      }

      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .searchBusByName(searchQuery);

      final List<BusEntity> buses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      return right<String, List<BusEntity>>(buses);
    } catch (error) {
      logError('BusRepository: Error searching buses ($searchQuery) - $error');
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        error,
      );
      return left<String, List<BusEntity>>(errorMessage);
    }
  }

  @override
  Future<Either<String, List<BusEntity>>> getBusesByServiceType(
    String serviceType,
  ) async {
    try {
      if (serviceType.trim().isEmpty) {
        return right<String, List<BusEntity>>([]);
      }

      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .getBusesByServiceType(serviceType);

      final List<BusEntity> buses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      return right<String, List<BusEntity>>(buses);
    } catch (error) {
      logError(
        'BusRepository: Error getting buses by service type ($serviceType) - $error',
      );
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        error,
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

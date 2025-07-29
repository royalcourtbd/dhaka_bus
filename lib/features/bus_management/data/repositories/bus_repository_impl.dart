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
  Future<Either<String, List<BusEntity>>> getAllBuses() async {
    try {
      logDebug('BusRepository: Getting all buses');

      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .getAllBuses();

      final List<BusEntity> buses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      logDebug('BusRepository: Successfully converted ${buses.length} buses');
      return right<String, List<BusEntity>>(buses);
    } catch (error) {
      logError('BusRepository: Error getting all buses - $error');
      final String errorMessage = _errorMessageHandler.generateErrorMessage(
        error,
      );
      return left<String, List<BusEntity>>(errorMessage);
    }
  }

  @override
  Future<Either<String, BusEntity?>> getBusById(String busId) async {
    try {
      logDebug('BusRepository: Getting bus by ID: $busId');

      if (busId.trim().isEmpty) {
        logDebug('BusRepository: Empty bus ID provided');
        return right<String, BusEntity?>(null);
      }

      final Map<String, dynamic>? busData = await _busRemoteDataSource
          .getBusById(busId);

      if (busData == null) {
        logDebug('BusRepository: No bus found with ID: $busId');
        return right<String, BusEntity?>(null);
      }

      final BusEntity bus = _mapToBusEntity(busData);
      logDebug('BusRepository: Successfully found bus: ${bus.busNameEn}');
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
      logDebug('BusRepository: Searching buses with query: $searchQuery');

      if (searchQuery.trim().isEmpty) {
        logDebug('BusRepository: Empty search query provided');
        return right<String, List<BusEntity>>([]);
      }

      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .searchBusByName(searchQuery);

      final List<BusEntity> buses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      logDebug(
        'BusRepository: Found ${buses.length} buses for query: $searchQuery',
      );
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
  Future<Either<String, List<BusEntity>>> getActiveBuses() async {
    try {
      logDebug('BusRepository: Getting active buses');

      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .getActiveBuses();

      final List<BusEntity> activeBuses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      logDebug(
        'BusRepository: Successfully got ${activeBuses.length} active buses',
      );
      return right<String, List<BusEntity>>(activeBuses);
    } catch (error) {
      logError('BusRepository: Error getting active buses - $error');
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
      logDebug('BusRepository: Getting buses by service type: $serviceType');

      if (serviceType.trim().isEmpty) {
        logDebug('BusRepository: Empty service type provided');
        return right<String, List<BusEntity>>([]);
      }

      final List<Map<String, dynamic>> busesData = await _busRemoteDataSource
          .getBusesByServiceType(serviceType);

      final List<BusEntity> buses = busesData
          .map((busData) => _mapToBusEntity(busData))
          .toList();

      logDebug(
        'BusRepository: Found ${buses.length} buses for service type: $serviceType',
      );
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

import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/settings/domain/datasource/app_settings_remote_data_source.dart';
import 'package:dhaka_bus/features/settings/domain/entities/app_settings_entity.dart';
import 'package:dhaka_bus/features/settings/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsRemoteDataSource _remoteDataSource;
  final ErrorMessageHandler _errorMessageHandler;

  AppSettingsRepositoryImpl(this._remoteDataSource, this._errorMessageHandler);

  @override
  Stream<Either<String, List<AppSettingsEntity>>> getAppSettings() {
    return _remoteDataSource
        .getAppSettingsStream()
        .map((settings) => right<String, List<AppSettingsEntity>>(settings))
        .handleError((error) {
          final String errorMessage = _errorMessageHandler.generateErrorMessage(
            error,
          );
          return left<String, List<AppSettingsEntity>>(errorMessage);
        });
  }
}

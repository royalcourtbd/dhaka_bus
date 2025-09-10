import 'package:dhaka_bus/core/services/backend_as_a_service.dart';
import 'package:dhaka_bus/core/utility/logger_utility.dart';
import 'package:dhaka_bus/features/settings/data/models/app_settings_model.dart';
import 'package:dhaka_bus/features/settings/domain/datasource/app_settings_remote_data_source.dart';

class AppSettingsRemoteDataSourceImpl implements AppSettingsRemoteDataSource {
  final BackendAsAService _backendAsAService;

  AppSettingsRemoteDataSourceImpl(this._backendAsAService);

  @override
  Stream<List<AppSettingsModel>> getAppSettingsStream() {
    return _backendAsAService.getAppSettingsStream().handleError((error) {
      logErrorStatic(
        "Error in getAppSettingsStream: $error",
        "AppSettingsRemoteDataSource",
      );
    });
  }
}

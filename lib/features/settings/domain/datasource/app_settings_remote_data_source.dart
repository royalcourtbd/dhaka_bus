import 'package:dhaka_bus/features/settings/data/models/app_settings_model.dart';

abstract class AppSettingsRemoteDataSource {
  Stream<List<AppSettingsModel>> getAppSettingsStream();
}

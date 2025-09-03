import 'package:dhaka_bus/features/settings/domain/entities/app_settings_entity.dart';

class AppSettingsModel extends AppSettingsEntity {
  const AppSettingsModel({required super.appVersion});

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(appVersion: json['app_version'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'app_version': appVersion};
  }
}

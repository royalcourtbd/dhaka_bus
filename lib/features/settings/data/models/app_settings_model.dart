import 'package:dhaka_bus/features/settings/domain/entities/app_settings_entity.dart';

class AppSettingsModel extends AppSettingsEntity {
  const AppSettingsModel({
    required super.appVersion,
    required super.changeLogs,
    required super.forceUpdate,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      appVersion: json['app_version'] as String,
      changeLogs: json['change_logs'] as String,
      forceUpdate: json['force_update'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_version': appVersion,
      'change_logs': changeLogs,
      'force_update': forceUpdate,
    };
  }
}

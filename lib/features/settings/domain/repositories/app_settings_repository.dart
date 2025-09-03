import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/settings/domain/entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Stream<Either<String, List<AppSettingsEntity>>> getAppSettings();
}

import 'package:dhaka_bus/core/base/base_entity.dart';

class AppSettingsEntity extends BaseEntity {
  final String appVersion;
  final String changeLogs;
  final bool forceUpdate;

  const AppSettingsEntity({
    required this.appVersion,
    required this.changeLogs,
    required this.forceUpdate,
  });

  @override
  List<Object?> get props => [appVersion, changeLogs, forceUpdate];
}

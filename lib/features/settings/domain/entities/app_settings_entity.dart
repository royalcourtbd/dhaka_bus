import 'package:dhaka_bus/core/base/base_entity.dart';

class AppSettingsEntity extends BaseEntity {
  final String appVersion;

  const AppSettingsEntity({required this.appVersion});

  @override
  List<Object?> get props => [appVersion];
}

// File Name : domain/usecase/get_app_version_usecase.dart

import 'package:dhaka_bus/core/base/base_export.dart';
import 'package:dhaka_bus/features/settings/domain/repositories/app_settings_repository.dart';

class GetAppVersionUseCase extends BaseUseCase<String?> {
  final AppSettingsRepository _repository;

  GetAppVersionUseCase(
    this._repository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Stream<Either<String, String?>> execute() {
    return _repository.getAppSettings().map((either) {
      return either.fold((failure) => left(failure), (settingsList) {
        if (settingsList.isNotEmpty) {
          // লিস্টের প্রথম আইটেম থেকে appVersion নিন
          return right(settingsList.first.appVersion);
        } else {
          // যদি কোনো সেটিংস না পাওয়া যায়
          return right(null);
        }
      });
    });
  }
}

import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/BackupService.dart';
import 'package:gomoney_finance_app/service/FCMservice.dart';
import 'package:gomoney_finance_app/service/IsolateService.dart';
import 'package:gomoney_finance_app/service/PackageInfoService.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerLazySingleton(() => IsolateService());
  locator.registerSingletonAsync<BackupService>(() async {
    final backupService = BackupService();
    await backupService.init();
    return backupService;
  });
  locator.registerSingletonAsync<FcmService>(() async {
    final fcmService = FcmService();
    await fcmService.init();
    return fcmService;
  });
  locator.registerSingletonAsync<PreferencesService>(() async {
    final preferencesService = PreferencesService();
    await preferencesService.init();
    return preferencesService;
  });
  locator.registerSingletonAsync<PackageInfoService>(() async {
    final packageInfoService = PackageInfoService();
    await packageInfoService.init();
    return packageInfoService;
  });
  locator.registerSingletonAsync<SqliteService>(() async {
    final sqliteService = SqliteService();
    await sqliteService.init();
    return sqliteService;
  });
}

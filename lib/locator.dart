import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/PackageInfoService.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
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
}

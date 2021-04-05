import 'package:package_info/package_info.dart';

class PackageInfoService {
  PackageInfo? packageInfo;
  Future<PackageInfoService> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    return this;
  }
}

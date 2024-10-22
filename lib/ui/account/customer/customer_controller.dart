import 'package:package_info_plus/package_info_plus.dart';
import 'package:rent_house/base/base_controller.dart';

class CustomerController extends BaseController {
  String version = '';

  @override
  void onInit() {
    super.onInit();
    getCurrentVersion();
  }

  Future<void> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }
}
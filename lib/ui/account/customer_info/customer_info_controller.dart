import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/ui/account/customer_info/nfc_screen.dart';
import 'package:rent_house/ui/qr_scan/qr_scan_screen.dart';

class CustomerInfoController extends BaseController {

  void useNFC () {
    Get.to(() => NfcScreen());
  }

  void useScanQR() {
    Get.to(() => QrScanScreen());
  }
}
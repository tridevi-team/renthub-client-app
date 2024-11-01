import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/ui/account/customer_info/nfc_screen.dart';

class CustomerInfoController extends BaseController {

  void useNFC () {
    Get.to(() => NFCReader());
  }
}
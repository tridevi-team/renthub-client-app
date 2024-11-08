import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/ui/account/customer_info/nfc_screen.dart';
import 'package:rent_house/ui/qr_scan/qr_scan_screen.dart';
import 'package:rent_house/untils/toast_until.dart';

class CustomerInfoController extends BaseController {

  String? citizenId, fullName, dateOfBirth, address;
  RxBool isVisible = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void useNFC () {
    Get.to(() => const NfcScreen());
  }

  void useScanQR() async {
    final scannedData = await Get.to(() => QrScanScreen());

    if (scannedData == null) {
      return;
    }

    List<String> parts = scannedData.split("||");
    if (parts.length < 2) {
      ToastUntil.toastNotification(description: 'Dữ liệu được quét không đầy đủ', status: ToastStatus.error);
      return;
    }

    citizenId = parts[0];

    List<String> infoParts = parts[1].split("|");

    fullName = infoParts.isNotEmpty ? infoParts[0] : "Tên không rõ";
    dateOfBirth = infoParts.length > 1 ? infoParts[1] : "Ngày sinh không rõ";
    address = infoParts.length > 2 ? infoParts[2] : "Địa chỉ không xác định";
    isVisible.value = false;
    isVisible.value = true;

  }
}
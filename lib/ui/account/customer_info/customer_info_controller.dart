import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/address_model.dart';
import 'package:rent_house/models/province/city.dart';
import 'package:rent_house/models/province/district.dart';
import 'package:rent_house/models/province/ward.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/ui/account/customer_info/nfc_screen.dart';
import 'package:rent_house/ui/qr_scan/qr_scan_screen.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/extensions/string_extension.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:rent_house/utils/toast_until.dart';

class CustomerInfoController extends BaseController {
  TextEditingController citizenIdCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController dateOfBirthCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  RxString selectedGender = 'other'.obs;
  int tempReg = 0;
  RxBool isVisible = true.obs;
  RxBool isEditInfo = false.obs;
  UserModel user = UserSingleton.instance.getUser();

  Rxn<City> citySelected = Rxn<City>();
  Rxn<District> districtSelected = Rxn<District>();
  Rxn<Ward> wardSelected = Rxn<Ward>();

  @override
  void onInit() {
    loadUserAddressInfo();
    super.onInit();
  }

  void useNFC() {
    Get.to(() => NFCScreen());
  }

  Future<void> useScanQR() async {
    final scannedData = await Get.to(() => QrScanScreen());

    if (scannedData == null || !scannedData.contains("||")) {
      ToastUntil.toastNotification(
        description: ConstantString.dataInvalidMessage,
        status: ToastStatus.error,
      );
      return;
    }

    final parts = scannedData.split("||");
    final infoParts = parts[1].split("|");

    citizenIdCtrl.text = parts[0];
    fullNameCtrl.text = infoParts.length > 0 ? infoParts[0] : "Tên không xác định";
    dateOfBirthCtrl.text = infoParts.length > 1 ? infoParts[1] : "Ngày sinh không xác định";
    addressCtrl.text = infoParts.length > 2 ? infoParts[2] : "Địa chỉ không xác định";

    final addressParts = addressCtrl.text.split(", ");
    String ward = "Phường/Xã không xác định";
    String district = "Quận/Huyện không xác định";
    String city = "Thành phố không xác định";

    for (var part in addressParts) {
      if (part.startsWith("Thôn") || part.startsWith("Xã")) {
        ward = part;
      } else if (part.startsWith("Huyện") || part.startsWith("Quận")) {
        district = part;
      } else {
        city = part;
      }
    }

    citySelected.value = _findMatchingOrFirst<City>(
      ProvinceSingleton.instance.provinces,
      city,
    );

    districtSelected.value = _findMatchingOrFirst<District>(
      citySelected.value?.districts ?? [],
      district,
    );

    wardSelected.value = _findMatchingOrFirst<Ward>(
      districtSelected.value?.wards ?? [],
      ward,
    );

    isVisible.value = false;
    isVisible.value = true;
  }

  void confirmResidenceRegistration({int? closeDialogRoute = 1}) {
    if (user.tempReg == 1 || !isEditInfo.value) return;
    DialogUtil.showDialogConfirm(
      onConfirm: () {
        tempReg = 1;
        isVisible.value = false;
        isVisible.value = true;
        if (closeDialogRoute != null) {
          Get.close(closeDialogRoute);
        }
      },
      title: ConstantString.titleTempReg,
      text: ConstantString.descriptionTempReg,
    );
  }

  Future<void> updateCustomerInfo() async {
    try {
      final updatedUser = user.copyWith(
        name: fullNameCtrl.text,
        birthday: FormatUtil.formatDate(dateOfBirthCtrl.text).toString(),
        citizenId: citizenIdCtrl.text,
        tempReg: tempReg,
        address: Address(
          city: citySelected.value?.name,
          district: districtSelected.value?.name,
          ward: wardSelected.value?.name,
          street: addressCtrl.text,
        ),
        gender: selectedGender.value,
      );


      DialogUtil.showLoading();
      final response = await CustomerService.updateCustomerInfo(user.id ?? '', updatedUser.toUpdateJson());
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      DialogUtil.showLoading();
      if (response.statusCode == 200) {
        UserSingleton.instance.setUser(updatedUser);
        isEditInfo.value = false;
      } else {
        ToastUntil.toastNotification(
          description: ConstantString.updateFailedMessage,
          status: ToastStatus.error,
        );
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error updating customer", message: "$e");
    }
  }

  void onChangeBirthday(DateTime time) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(time);
    dateOfBirthCtrl.text = formattedDate;
    isVisible.value = false;
    isVisible.value = true;
  }

  void onCitySelected(City city) {
    citySelected.value = city;
    districtSelected.value = city.districts?[0];
    wardSelected.value = city.districts?[0].wards?[0];
    Get.close(1);
  }

  void onDistrictSelected(District district) {
    districtSelected.value = district;
    wardSelected.value = district.wards?[0];
    Get.close(1);
  }

  void onWardSelected(Ward ward) {
    wardSelected.value = ward;
    Get.close(1);
  }

  void loadUserAddressInfo() {
    citizenIdCtrl.text = user.citizenId ?? '';
    fullNameCtrl.text = user.name ?? '';
    dateOfBirthCtrl.text = FormatUtil.formatToDayMonthYear(user.birthday);
    addressCtrl.text = user.address?.street ?? '';
    selectedGender.value = user.gender ?? '';
    tempReg = user.tempReg ?? 0;
    citySelected.value = _findMatchingOrFirst<City>(
      ProvinceSingleton.instance.provinces,
      user.address?.city,
    );

    districtSelected.value = _findMatchingOrFirst<District>(
      citySelected.value?.districts ?? [],
      user.address?.district,
    );

    wardSelected.value = _findMatchingOrFirst<Ward>(
      districtSelected.value?.wards ?? [],
      user.address?.ward,
    );
  }

  T? _findMatchingOrFirst<T>(List<T> items, String? name) {
    if (name?.isNotEmpty ?? false) {
      final trimmedName = name!.toLowerCase().removeSign();
      return items.firstWhere(
        (item) => _getName(item)?.toLowerCase().removeSign().contains(trimmedName) ?? false,
        orElse: () => items.first,
      );
    }
    return items.isNotEmpty ? items.first : null;
  }

  String? _getName(dynamic item) {
    if (item is City) return item.name;
    if (item is District) return item.name;
    if (item is Ward) return item.name;
    return null;
  }

  void cancelUpdateInfo() {
    isEditInfo.toggle();
    loadUserAddressInfo();
  }
}

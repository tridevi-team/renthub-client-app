import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
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
import 'package:rent_house/ui/account/customer/customer_controller.dart';
import 'package:rent_house/ui/account/customer_info/qr_scan/qr_scan_screen.dart';
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
  RxString nameUser = "".obs;

  Rxn<City> citySelected = Rxn<City>();
  Rxn<District> districtSelected = Rxn<District>();
  Rxn<Ward> wardSelected = Rxn<Ward>();

  @override
  void onInit() {
    loadUserAddressInfo();
    super.onInit();
  }

  Future<void> useScanQR() async {
    String scannedData = await Get.to(() => QrScanScreen());
    parseUserInfo(scannedData);
  }

  void parseUserInfo(String data, {bool isNFC = false}) {
    if (!data.contains("||")) {
      ToastUntil.toastNotification(
        description: ConstantString.dataInvalidMessage,
        status: ToastStatus.error,
      );
      return;
    }
    final parts = data.split("||");
    final infoParts = parts[1].split("|");

    citizenIdCtrl.text = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    fullNameCtrl.text = infoParts.isNotEmpty ? infoParts[0] : "Tên không xác định";
    dateOfBirthCtrl.text = infoParts.length > 1 ? FormatUtil.formatDateOfBirth(infoParts[1]) : FormatUtil.formatToDayMonthYear(DateTime.now().toIso8601String());

    List addressParts;
    if (isNFC) {
      selectedGender.value = parseGender(infoParts.length > 2 ? infoParts[2] : 'other');
      addressParts = infoParts.length > 3 ? infoParts[3].split(",") : [];
    } else {
      addressParts = infoParts.length > 2 ? infoParts[2].split(",") : [];
    }
    if (addressParts.length >= 3) {
      String city = addressParts[2];
      String district = addressParts[1];
      String ward = addressParts[0];
      addressCtrl.text = ward;

      citySelected.value = _findMatchingOrFirst<City>(
        ProvinceSingleton.instance.provinces,
        city,
      );
      districtSelected.value = _findMatchingOrFirst<District>(
        citySelected.value?.districts ?? [],
        district,
      );
      wardSelected.value = districtSelected.value?.wards?[0];
    } else {
      addressCtrl.text = "";
      citySelected.value = ProvinceSingleton.instance.provinces[0];
      districtSelected.value = citySelected.value?.districts?[0];
      wardSelected.value = districtSelected.value?.wards?[0];
    }
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
      DialogUtil.hideLoading();
      if (response.statusCode == 200) {
        UserSingleton.instance.setUser(updatedUser);
         Get.find<CustomerController>().nameUser.value = updatedUser.name ?? "";
        nameUser.value = updatedUser.name ?? "";
        isEditInfo.value = false;
        ToastUntil.toastNotification(
          description: ConstantString.updateSuccessMessage,
          status: ToastStatus.success,
        );
        return;
      } else {
        ToastUntil.toastNotification(
          description: ConstantString.updateFailedMessage,
          status: ToastStatus.error,
        );
        return;
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
    nameUser.value = user.name ?? "";
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
      final trimmedName = name?.toLowerCase().removeSign() ?? "khong xac dinh";
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

  Future<void> checkNFCStatus() async {
    try {
      NFCAvailability nfcStatus = await FlutterNfcKit.nfcAvailability;
      if (nfcStatus == NFCAvailability.not_supported) {
        throw Exception('NFC is unavailable');
      } else if (nfcStatus == NFCAvailability.disabled) {
        ToastUntil.toastNotification(description: "Để sử dụng chức năng này vui lòng bật NFC trên thiết bị và thử lại.", status: ToastStatus.warning);
      } else {
        _readNFC();
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "NFC status", message: "$e");
      ToastUntil.toastNotification(description: "NFC is not supported on this device.", status: ToastStatus.error);
    }
  }

  Future<void> _readNFC() async {
    try {
      DialogUtil.showNFCAnimation();
      await FlutterNfcKit.poll();
      final ndefRecords = await FlutterNfcKit.readNDEFRecords();
      final ndefData = ndefRecords.map((record) => record.payload ?? <int>[]).expand((element) => element).toList();
      String nfcData = utf8.decode(ndefData);
      await FlutterNfcKit.finish().then((value) => Get.close(1));
      parseUserInfo(nfcData, isNFC: true);
    } catch (e) {
      ToastUntil.toastNotification(description: "Có lỗi xảy ra. Vui lòng thử lại hoặc cập nhật thông tin thủ công.", status: ToastStatus.error);
      AppUtil.printDebugMode(type: "NFC Error", message: "$e");
    }
  }

  String parseGender(String gender) {
    gender = gender.toLowerCase().removeSign();
    if (gender.toLowerCase().removeSign() == "nam") {
      return "male";
    } else if (gender == "nu") {
      return "female";
    } else {
      return "other";
    }
  }
}

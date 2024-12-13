import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/contract_model.dart';
import 'package:rent_house/services/contract_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/format_util.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:rent_house/utils/toast_until.dart';

class CustomerContractController extends BaseController with GetTickerProviderStateMixin {
  final List<Widget> contractTabs = <Widget>[
    const Tab(text: 'Chờ phê duyệt'),
    const SizedBox(width: 80, child: Tab(text: 'Đã ký')),
    const Tab(text: 'Đã từ chối'),
  ];

  late TabController contractTabController;
  RefreshController contractRefreshCtrl = RefreshController();
  int currentContractTabIndex = 0;
  int prevContractTabIndex = 0;
  String _roomId = "";

  List<ContractModel> contracts = [];

  static const _units = ['', 'một', 'hai', 'ba', 'bốn', 'năm', 'sáu', 'bảy', 'tám', 'chín'];
  static const _tens = ['', '', 'hai mươi', 'ba mươi', 'bốn mươi', 'năm mươi', 'sáu mươi', 'bảy mươi', 'tám mươi', 'chín mươi'];

  @override
  void onInit() {
    super.onInit();
    _roomId = UserSingleton.instance.getUser().roomId ?? "";
    contractTabController = TabController(length: contractTabs.length, vsync: this);
    getContractHistoryTab(isRefresh: true);
  }

  void changeTab(int tabIndex) {
    if (tabIndex != currentContractTabIndex) {
      prevContractTabIndex = currentContractTabIndex;
      currentContractTabIndex = tabIndex;
      contractTabController.animateTo(tabIndex, duration: const Duration(milliseconds: 0));
      getContractHistoryTab(isRefresh: true);
    }
  }

  Future<void> getContractHistoryTab({bool isRefresh = false}) async {
    viewState.value = ViewState.init;
    if (isRefresh) {
      contracts.clear();
      viewState.value = ViewState.loading;
    }
    try {
      viewState.value = ViewState.loading;
      final response = await ContractService.getAllContractInRoom(roomId: _roomId);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (decodedResponse["data"]["results"] != null && decodedResponse["data"]["results"] is List) {
          List<ContractModel> filteredContracts = (decodedResponse["data"]["results"] as List).map((contract) => ContractModel.fromJson(contract)).toList();

          switch (currentContractTabIndex) {
            case 0:
              filteredContracts = getContractsByStatus(filteredContracts, 'PENDING');
              break;
            case 1:
              filteredContracts = getContractsByStatus(filteredContracts, 'APPROVED');
              break;
            case 2:
              filteredContracts = getContractsByStatus(filteredContracts, 'REJECTED');
              break;
            default:
              filteredContracts = [];
          }

          contracts = filteredContracts;
          if (contracts.isEmpty) {
            viewState.value = ViewState.noData;
            return;
          } else {
            viewState.value = ViewState.complete;
            return;
          }
        }

        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: 'Contract Error', message: "$e");
    }
  }

  List<ContractModel> getContractsByStatus(List<ContractModel> contractsList, String status) {
    return contractsList.where((contract) => contract.approvalStatus == status).toList();
  }

  String replaceKeyHtml(String html, Map<String, String> values) {
    values.forEach((key, value) {
      html = html.replaceAll('{{$key}}', value);
    });
    return html;
  }

  String generateContractHtml(ContractModel contract) {
    Map<String, String> placeholders = {
      "CURRENT_DATE": contract.approvalDate != null ? FormatUtil.formatToDayMonthYear(contract.approvalDate.toString()) : "Chưa ký",
      "HOST_NAME": "${contract.landlord?.fullName}",
      "OWNER_ADDRESS": '${contract.landlord?.address?.toString()}',
      "OWNER_IDENTITY_NUMBER": "${contract.landlord?.citizenId}",
      "OWNER_DATE_OF_ISSUANCE": "${contract.landlord?.dateOfIssue}",
      "OWNER_PLACE_OF_ISSUE": "${contract.landlord?.placeOfIssue}",
      "OWNER_PHONE": "${contract.landlord?.phoneNumber}",
      "RENTER_NAME": "${contract.renter?.fullName}",
      "RENTER_ADDRESS": '${contract.renter?.address?.toString()}',
      "RENTER_IDENTITY_NUMBER": "${contract.renter?.citizenId}",
      "RENTER_DATE_OF_ISSUANCE": "${contract.renter?.dateOfIssue}",
      "RENTER_PLACE_OF_ISSUE": "${contract.renter?.placeOfIssue}",
      "RENTER_PHONE_NUMBER": "${contract.renter?.phoneNumber}",
      "RENTAL_HOUSE_ADDRESS": "${contract.room?.house?.address.toString()}",
      "HOUSE_NAME": "${contract.room?.house?.name}",
      "SQUARE_METER": "${contract.room?.area.toString()}",
      "ROOM_NAME": "${contract.room?.name}",
      "CONTRACT_START_DATE": FormatUtil.formatToDayMonthYear(contract.rentalStartDate?.toString()),
      "CONTRACT_END_DATE": FormatUtil.formatToDayMonthYear(contract.rentalEndDate?.toString()),
      "COLLECTION_CYCLE": "Hàng tháng",
      "RENT_COST": FormatUtil.formatCurrency(contract.depositAmount ?? 0),
      "DEPOSIT_AMOUNT": FormatUtil.formatCurrency(contract.depositAmount ?? 0),
      "RENTAL_AMOUNT_IN_WORDS": numberToVietnameseWords(contract.depositAmount ?? 0),
      "DEPOSIT_AMOUNT_IN_WORDS": numberToVietnameseWords(contract.depositAmount ?? 0),
      "USE_SERVICES": contract.services != null ? '<ul>${contract.services!.map((service) => '<li><strong>${service.name}:</strong> ${FormatUtil.formatCurrency(service.unitPrice ?? 0)}</li>').join('')}</ul>' : '',
      //"ROOM_VEHICLE_LIST": contract.equipment != null ? contract.equipment!.map((e) => e.name).join(', ') : '',
      "EQUIPMENT_LIST": contract.equipment != null ? '<ul>${contract.equipment!.map((item) => '<li><strong>${item.name}:</strong> x1</li>').join('')}</ul>' : '',
      "CONTRACT_MONTHS": "${calculateMonthsBetweenDates(rentalStartDate: contract.rentalStartDate?.toString() ?? "", rentalEndDate: contract.rentalEndDate?.toString() ?? "")}",
      "FEE_COLLECTION_DAY": FormatUtil.formatToDayMonthYear(contract.depositDate?.toString())
    };

    return replaceKeyHtml(contract.content ?? "", placeholders);
  }

  int calculateMonthsBetweenDates({
    required String rentalStartDate,
    required String rentalEndDate,
  }) {
    if (rentalStartDate == "" || rentalEndDate == "") return 0;
    DateTime startDate = DateTime.parse(rentalStartDate);
    DateTime endDate = DateTime.parse(rentalEndDate);

    int yearDiff = endDate.year - startDate.year;
    int monthDiff = endDate.month - startDate.month;

    return yearDiff * 12 + monthDiff;
  }

  String numberToVietnameseWords(int number) {
    if (number == 0) return 'không đồng';
    List<String> groups = [];
    int groupIndex = 0;
    while (number > 0) {
      int group = number % 1000;
      if (group > 0) {
        String groupWords = convertThreeDigitGroup(group);
        if (groupIndex == 1) {
          groupWords += ' nghìn';
        } else if (groupIndex == 2) {
          groupWords += ' triệu';
        } else if (groupIndex == 3) {
          groupWords += ' tỷ';
        }
        groups.insert(0, groupWords);
      }
      number ~/= 1000;
      groupIndex++;
    }
    return '${groups.join(' ').trim()} đồng';
  }

  String convertThreeDigitGroup(int num) {
    int hundred = num ~/ 100;
    int remainder = num % 100;
    int ten = remainder ~/ 10;
    int unit = remainder % 10;

    String result = '';
    if (hundred > 0) {
      result += '${_units[hundred]} trăm ';
    }
    if (ten > 1) {
      result += _tens[ten];
      if (unit > 0) result += ' ${_units[unit]}';
    } else if (ten == 1) {
      result += 'mười';
      if (unit > 0) {
        if (unit == 5) {
          result += ' lăm';
        } else {
          result += ' ${_units[unit]}';
        }
      }
    } else if (unit > 0) {
      if (hundred > 0) result += ' lẻ';
      result += ' ${_units[unit]}';
    }
    return result.trim();
  }

  String getStatusName(String contractStatus) {
    if (contractStatus == 'PENDING') return "Chờ phê duyệt";
    if (contractStatus == 'APPROVED') return "Đã ký";
    if (contractStatus == 'REJECTED') return "Đã từ chối";
    return "Chờ phê duyệt";
  }

  Future<void> updateStatusContract(String contractId, String status) async {
    try {
      DialogUtil.showLoading();
      final response = await ContractService.updateContractStatus(contractId: contractId, body: {"status": status});
      DialogUtil.hideLoading();
      if (response.statusCode == 200) {
        ToastUntil.toastNotification(description: "Cập nhật hợp đồng thành công", status: ToastStatus.success);
        Get.back();
        changeTab(1);
        return;
      }
      ToastUntil.toastNotification(description: "Cập nhật hợp đồng thất bại. Vui lòng thử lại.", status: ToastStatus.error);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
    } catch (e) {
      DialogUtil.hideLoading();
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: 'Contract Update Error', message: "$e");
    }
  }
}

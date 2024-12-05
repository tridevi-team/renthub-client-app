import 'dart:convert';

import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/issue_model.dart';
import 'package:rent_house/services/issue_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class DetailIssueController extends BaseController {

  String _issueId = "";
  IssueModel? issueModel;

  @override
  void onInit() {
    _issueId = Get.arguments["issueId"];
    getBillDetails();
    super.onInit();
  }

  Future<void> getBillDetails() async {
    try {
      viewState.value = ViewState.loading;
      final response = await IssueService.fetchDetailIssue(issueId: _issueId);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        issueModel = IssueModel.fromJson(decodedResponse['data']);
        viewState.value = ViewState.complete;
        return;
      }
      if (decodedResponse['data'] == null) {
        viewState.value = ViewState.noData;
        return;
      }

      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
    } catch (e) {
      viewState.value = ViewState.notFound;
      AppUtil.printDebugMode(type: "bill detail", message: "$e");
    }
  }
}
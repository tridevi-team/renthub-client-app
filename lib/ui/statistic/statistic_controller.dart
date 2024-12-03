import 'dart:convert';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/services/statistic_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';

class StatisticsController extends BaseController {

  String _roomId = "";
  @override
  void onInit() {
    _roomId = UserSingleton.instance.getUser().roomId ?? "";
    getChartByRoom();
    super.onInit();
  }

  Future<void> getChartByRoom() async {
    try {
      viewState.value = ViewState.loading;
      final response = await StatisticService.getChartByRoom(_roomId);
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {

        viewState.value = ViewState.complete;
      }
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
    } catch (e) {
      AppUtil.printDebugMode(type: 'fetch chart', message: "$e");
      return;
    }
  }
}
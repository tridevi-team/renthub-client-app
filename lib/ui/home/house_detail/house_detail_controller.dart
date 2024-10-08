import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/services/home_service.dart';

class HouseDetailController extends BaseController {

  String houseId = '';
  late House currentHouse;
  late RefreshController refreshController;
  ExpandableController expandableController = ExpandableController();
  late Room selectedRoom;


  @override
  void onInit() {
    houseId = Get.arguments['houseId'] ?? '';
    fetchHouseInformation();
    super.onInit();
  }

  Future<void> fetchHouseInformation() async {
    viewState.value = ViewState.loading;
    final response = await HomeService.fetchHouseInformation(houseId);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    currentHouse = House.fromJson(json['data']);
    viewState.value = ViewState.complete;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/services/home_service.dart';

class HouseDetailController extends BaseController {

  String houseId = '';
  House currentHouse = House();


  @override
  void onInit() {
    super.onInit();
    houseId = Get.arguments['houseId'] ?? '';
    fetchHouseInformation();
  }

  Future<void> fetchHouseInformation() async {
    viewState.value = ViewState.loading;
    final response = await HomeService.fetchHouseInformation(houseId);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    currentHouse = House.fromJson(json['data']);
    viewState.value = ViewState.complete;
  }

}
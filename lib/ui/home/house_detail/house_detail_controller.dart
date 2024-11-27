import 'dart:convert';

import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/untils/response_error_util.dart';

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
    try {
      viewState.value = ViewState.loading;
      final response = await HomeService.fetchHouseInformation(houseId);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        currentHouse = House.fromJson(decodedResponse['data']);
        sortHouseDetails();
        viewState.value = ViewState.complete;
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
    }
  }

  void sortHouseDetails() {
    currentHouse.floors?.sort((floor1, floor2) {
      return _compareNames(floor1.name, floor2.name);
    });

    for (var floor in currentHouse.floors ?? []) {
      floor.rooms.sort((room1, room2) {
        return _compareNames(room1.name, room2.name);
      });
    }
  }

  int _compareNames(String? name1, String? name2) {
    if (name1 == null && name2 == null) return 0;
    if (name1 == null) return -1;
    if (name2 == null) return 1;
    return name1.compareTo(name2);
  }
}

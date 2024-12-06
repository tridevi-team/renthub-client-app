import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/explore_model.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/home/home_explore/home_explore.dart';
import 'package:rent_house/utils/response_error_util.dart';

class HomeController extends BaseController {
  //controller
  RefreshController refreshController = RefreshController();
  ScrollController scrollCtrl = ScrollController();

  //widgets
  RxList<Widget> widgets = <Widget>[].obs;

  //data
  List<Explore> exploreList = [
    Explore(id: 1, name: "Explore 1", image: "image1", description: "Description 1", quantity: 50),
    Explore(id: 2, name: "Explore 2", image: "image2", description: "Description 2", quantity: 60),
    Explore(id: 3, name: "Explore 3", image: "image3", description: "Description 3", quantity: 70),
  ];

  List<House> houseList = [];
  RxList<House> recentHouse = <House>[].obs;
  int currentPage = 1;


  @override
  void onInit() {
    super.onInit();
    _buildExploreWidget();
    fetchHouseList();
  }

  void _buildExploreWidget() {
    widgets.add(const HomeExplore());
  }

  Future<void> fetchHouseList({
    bool isLoadMore = false,
    int? numOfBeds,
    String? street,
    String? ward,
    String? district,
    String? city,
    int? numOfRenters,
    int? roomArea,
    int? priceFrom,
    int? priceTo,
    int limit = 10,
  }) async {
    try {
      viewState.value = ViewState.init;
      if (isLoadMore) {
        currentPage++;
      } else {
        viewState.value = ViewState.loading;
        currentPage = 1;
      }

      String sort = '''sort[]={
       "field": "houses.name",
          "direction": "asc"
        }''';

      String filters = '''filter[]={
        "field": "houses.name",
        "operator": "cont",
        "value": ""
        }&
        ''';

      final response = await HomeService.fetchHouseList(sort, filters, currentPage);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        HouseDataModel houseDataModel = HouseDataModel.fromJson(decodedResponse['data']);
        viewState.value = ViewState.complete;
        if (houseDataModel.results != null && houseDataModel.results!.isNotEmpty) {
          if (!isLoadMore) {
            houseList.clear();
          }
          houseList.addAll(houseDataModel.results!);
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      refreshController.loadNoData();
      log("Error fetch: $e");
    }
  }

  void onLoadMoreHouse() async {
    await fetchHouseList(isLoadMore: true);
  }

  void onRefreshData() async {
    await fetchHouseList();
    refreshController.requestRefresh();
  }

  void addToRecentHouse(House item) {
    for (var house in recentHouse) {
      if (house.id == item.id) {
        return;
      }
    }
    if (recentHouse.length == 10) {
      recentHouse.removeAt(recentHouse.length - 1);
    }
    recentHouse.insert(0, item);
  }
}

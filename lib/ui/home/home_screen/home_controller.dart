import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/models/explore_model.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/home/home_explore/home_explore.dart';

class HomeController extends BaseController {
  //controller
  RefreshController refreshController = RefreshController();
  ScrollController scrollController = ScrollController();

  //widgets
  RxList<Widget> widgets = <Widget>[].obs;

  //data
  List<Explore> exploreList = [
    Explore(id: 1, name: "Explore 1", image: "image1", description: "Description 1", quantity: 50),
    Explore(id: 2, name: "Explore 2", image: "image2", description: "Description 2", quantity: 60),
    Explore(id: 3, name: "Explore 3", image: "image3", description: "Description 3", quantity: 70),
  ];

  List<House> houseList = [];
  int currentPage = 1;


  @override
  void onInit() {
    super.onInit();
    _buildExploreWidget();
    fetchHouseList();
  }

  void _buildExploreWidget() {
    widgets.add(HomeExplore());
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
    int page = 1
  }) async {
    try {
      viewState.value = ViewState.init;
      if (isLoadMore) {
        currentPage++;
      } else {
        viewState.value = ViewState.loading;
        currentPage = 1;
      }

      String sort = '''{
       "field": "houses.name",
          "direction": "asc"
        }''';

      List<String> filters = [];
      filters.add(
        '''filter[]={
        "field": "houses.name",
        "operator": "cont",
        "value": ''
        }&
        '''
      );

      final response = await HomeService.fetchHouseList(sort, filters, page);

      if (response.statusCode != 200) {
        viewState.value = ViewState.error;
        log("Failed to fetch house list, status code: ${response.statusCode}");
        return;
      }
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
    } catch (e) {
      viewState.value = ViewState.error;
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
}

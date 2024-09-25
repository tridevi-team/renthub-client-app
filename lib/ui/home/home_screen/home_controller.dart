import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/models/explore_model.dart';
import 'package:rent_house/ui/home/home_explore/home_explore.dart';
import 'package:rent_house/ui/home/home_list/home_list.dart';

class HomeController extends BaseController {

  //controller
  RefreshController refreshController = RefreshController();

  //status
  RxBool isLoadingRefresh = false.obs;

  //data
  List<Explore> exploreList = [
    Explore(id: 1, name: "Explore 1", image: "image1", description: "Description 1"),
    Explore(id: 2, name: "Explore 2", image: "image2", description: "Description 2"),
    Explore(id: 3, name: "Explore 3", image: "image3", description: "Description 3"),
  ];
  
  //widgets
  RxList<Widget> widgets = <Widget>[].obs;

  @override
  void onInit() {
    super.onInit();
    _buildExploreWidget();
  }

  void _buildExploreWidget() {
    widgets.add(HomeExplore(exploreList: exploreList));
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';

class HomeController extends BaseController {

  RxBool isLoadingRefresh = false.obs;
  RxList<Widget> widgets = <Widget>[].obs;

}
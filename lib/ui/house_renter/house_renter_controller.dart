import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/constants/web_service.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/models/rss_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

class HouseRenterController extends BaseController {
  RxBool isVisible = true.obs;
  final List<RssModel> rssList = [];
  Room room = Room();
  final List<UserModel> memberList = [];

  @override
  void onInit() {
    onRefreshData();
    super.onInit();
  }

  Future<void> fetchNews() async {
    try {
      viewState.value = ViewState.loading;
      final response = await http.get(Uri.parse(WebService.rssUrl));
      if (response.statusCode < 300) {
        final xmlDoc = XmlDocument.parse(response.body);
        rssList.clear();
        rssList.addAll(xmlDoc.findAllElements('item').map((element) {
          return RssModel(
            title: _getElementText(element, 'title'),
            description: _getPlainText(_getElementText(element, 'description')),
            link: _getElementText(element, 'link'),
            pubDate: _getElementText(element, 'pubDate'),
            imageUrl: element.findElements('enclosure').map((e) => e.getAttribute('url')).firstOrNull ?? '',
          );
        }));
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in fetchNews", message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  Future<void> getRoomInfo() async {
    try {
      viewState.value = ViewState.loading;
      final roomId = UserSingleton.instance.getUser().roomId;
      if (roomId?.isEmpty ?? true) return;
      final response = await CustomerService.fetchRoomDetails(roomId: roomId!);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        room = Room.fromJson(decodedResponse["data"]);
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in getRoomInfo", message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  Future<void> getRoomMember() async {
    try {
      memberList.clear();
      viewState.value = ViewState.loading;
      final roomId = UserSingleton.instance.getUser().roomId;
      if (roomId?.isEmpty ?? true) return;
      final response = await CustomerService.fetchRoomMembers(roomId: roomId!);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final results = decodedResponse["data"]['results'] as List<dynamic>? ?? [];
        memberList.addAll(results.map((data) => UserModel.fromJson(data)));
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in getRoomMember", message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  Future<void> fetchEquipmentByHouseId() async {
    try {
      viewState.value = ViewState.loading;
      final houseId ='';
      if (houseId.isEmpty) return;
      final response = await CustomerService.fetchRoomMembers(roomId: houseId);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final results = decodedResponse["data"] as List<dynamic>? ?? [];
        memberList.addAll(results.map((data) => UserModel.fromJson(data)));
        viewState.value = ViewState.complete;
      } else {
        ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in getRoomMember", message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  Future<void> onRefreshData() async {
    try {
      await Future.wait([
        getRoomMember(),
        fetchNews(),
        getRoomInfo(),
      ]);
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in onRefreshData", message: "$e");
      viewState.value = ViewState.notFound;
    }
  }

  String _getElementText(XmlElement element, String tag) {
    return element.findElements(tag).map((e) => e.innerText).firstOrNull ?? '';
  }

  String _getPlainText(String htmlString) {
    final cleanedHtml = htmlString.replaceAll(RegExp(r'<!\[CDATA\[(.*?)\]\]>'), '\$1');
    final document = html.parse(cleanedHtml);
    return document.body?.text.trim() ?? '';
  }

  String getIconForServiceType(String serviceType) {
    String path = AssetSvg.iconBed;
    if (serviceType == ConstantString.serviceTypeElectric) {
      path = AssetSvg.iconPlug;
    } else if (serviceType == ConstantString.serviceTypeWater) {
      path = AssetSvg.iconWater;
    } else if (serviceType == ConstantString.serviceTypePeople) {
      path = AssetSvg.iconPerson;
    } else {
      path = AssetSvg.iconBed;
    }
    return path;
  }
}

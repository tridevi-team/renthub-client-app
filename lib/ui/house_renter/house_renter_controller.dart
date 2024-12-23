import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/room_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/constants/web_service.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/models/rss_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

class HouseRenterController extends BaseController {
  RxBool isVisible = true.obs;
  final List<RssModel> rssList = [];
  Room room = Room();
  final List<UserModel> memberList = [];

  @override
  void onInit() {
    super.onInit();
    onRefreshData();
  }

  Future<ViewState> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(WebService.rssUrl));
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
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
        return ViewState.complete;
      } else {
        return ViewState.notFound;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in fetchNews", message: "$e");
      return ViewState.serverError;
    }
  }

  Future<ViewState> getRoomInfo() async {
    try {
      final roomId = UserSingleton.instance.getUser().roomId;
      if (roomId?.isEmpty ?? true) return ViewState.notFound;

      final response = await CustomerService.fetchRoomDetails(roomId: roomId!);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        room = Room.fromJson(decodedResponse["data"]);
        RoomSingleton.instance.setRoomName(room.name ?? "");
        RoomSingleton.instance.setHouseName(room.house?.name ?? "");
        return ViewState.complete;
      } else {
        return viewState.value;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in getRoomInfo", message: "$e");
      return ViewState.serverError;
    }
  }

  Future<ViewState> getRoomMember() async {
    try {
      memberList.clear();
      final roomId = UserSingleton.instance.getUser().roomId;
      if (roomId?.isEmpty ?? true) return ViewState.notFound;

      final response = await CustomerService.fetchRoomMembers(roomId: roomId!);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final results = decodedResponse["data"]['results'] as List<dynamic>? ?? [];
        memberList.addAll(results.map((data) => UserModel.fromJson(data)));
        return ViewState.complete;
      } else {
        return viewState.value;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in getRoomMember", message: "$e");
      return ViewState.serverError;
    }
  }

  Future<ViewState> fetchEquipmentByHouseId() async {
    try {
      String houseId = UserSingleton.instance.getUser().houseId ?? '';
      if (houseId.isEmpty) return ViewState.notFound;

      final response = await CustomerService.fetchRoomMembers(roomId: houseId);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final results = decodedResponse["data"] as List<dynamic>? ?? [];
        memberList.addAll(results.map((data) => UserModel.fromJson(data)));
        return ViewState.complete;
      } else {
        return viewState.value;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in fetchEquipmentByHouseId", message: "$e");
      return ViewState.serverError;
    }
  }


  Future<void> onRefreshData() async {
    try {
      viewState.value = ViewState.loading;

      final List<Future<ViewState>> apiCalls = [
        getRoomMember(),
        fetchNews(),
        getRoomInfo(),
      ];

      final List<ViewState> results = await Future.wait(apiCalls);

      if (results.every((state) => state == ViewState.complete)) {
        viewState.value = ViewState.complete;
      } else if (results.contains(ViewState.serverError)) {
        viewState.value = ViewState.serverError;
      } else if (results.contains(ViewState.notFound)) {
        viewState.value = ViewState.notFound;
      } else {
        viewState.value = ViewState.init;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in onRefreshData", message: "$e");
      viewState.value = ViewState.serverError;
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
    }
    return path;
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/constants/web_service.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/models/rss_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/toast_until.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

class HouseRenterController extends BaseController {
  RxBool isVisible = true.obs;
  List<RssModel> rssList = [];
  Room room = Room();

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(WebService.rssUrl));

      if (response.statusCode == 200) {
        final xmlDoc = XmlDocument.parse(response.body);
        final items = xmlDoc.findAllElements('item');

        rssList = items.map((element) {
          final title = _getElementText(element, 'title');
          final description = _getElementText(element, 'description');
          final link = _getElementText(element, 'link');
          final pubDate = _getElementText(element, 'pubDate');
          final imageUrl = element.findElements('enclosure').map((e) => e.getAttribute('url')).firstOrNull ?? '';

          return RssModel(
            title: title,
            description: _getPlainText(description),
            link: link,
            pubDate: pubDate,
            imageUrl: imageUrl,
          );
        }).toList();
        _notifyChange();
      } else {
        throw Exception('Failed to load RSS feed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in fetchNews", message: "$e");
    }
  }

  String _getElementText(XmlElement element, String tag) {
    final elements = element.findElements(tag);
    if (elements.isNotEmpty) {
      return elements.first.innerText;
    }
    return '';
  }

  String _getPlainText(String htmlString) {
    String cleanedHtml = htmlString.replaceAll(RegExp(r'<!\[CDATA\[(.*?)\]\]>'), '\$1');

    final document = html.parse(cleanedHtml);

    return document.body?.text.trim() ?? '';
  }

  void _notifyChange() {
    isVisible.value = false;
    isVisible.value = true;
  }

  Future<void> getRoomInfo() async {
    try {
      viewState.value = ViewState.loading;
      final roomId = UserSingleton.instance.getUser().roomId;
      if (roomId?.isEmpty ?? true) return;
      final response = await CustomerService.fetchRoomDetails(roomId: roomId ?? '');
      if (response.statusCode == 500) {
        viewState.value = ViewState.noInternetConnection;
      } else if (response.statusCode == 408) {
        viewState.value = ViewState.timeout;
      } else if (response.statusCode == 1000 || response.statusCode > 500) {
        viewState.value = ViewState.serverError;
      } else if (response.statusCode >= 300) {
        viewState.value = ViewState.notFound;
      } else {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        room = Room.fromJson(decodedResponse["data"]);
        viewState.value = ViewState.complete;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "Error in getRoomInfo", message: "$e");
    }
  }

  Future<void> onRefreshData() async {
    Future.wait([
      fetchNews(),
      getRoomInfo(),
    ]);
  }
}

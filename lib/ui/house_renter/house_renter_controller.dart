import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/web_service.dart';
import 'package:rent_house/models/rss_model.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

class HouseRenterController extends BaseController {
  RxBool isVisible = true.obs;
  List<RssModel> rssList = [];

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
          final imageUrl = element
              .findElements('enclosure')
              .map((e) => e.getAttribute('url'))
              .firstOrNull ?? '';

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
}

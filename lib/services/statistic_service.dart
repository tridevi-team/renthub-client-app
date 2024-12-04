import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class StatisticService {

  static Future<http.Response> getChartByRoom(String roomId, String fromDate, String toDate) {
    String endpoint = '/statistical/$roomId/room-chart?from=$fromDate&to=$toDate';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
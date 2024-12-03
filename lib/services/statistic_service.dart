import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class StatisticService {

  static Future<http.Response> getChartByRoom(String roomId) {
    String endpoint = '/statistical/$roomId/room-chart?from=2023-01-01&to=2025-12-31';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
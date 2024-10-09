import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class HomeService {
  static Future<http.Response> fetchHouseList(Map<String, dynamic> queryParams) {
    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint = '/houses/search/?$queryString';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchHouseInformation(String houseId) {
    String endpoint = '/houses/$houseId/rooms/';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}

import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class HomeService {
  static Future<http.Response> fetchHouseList(String sort, String filters, int page,
      {int pageSize = 10}) {

    String endpoint = '/houses/search?$filters$sort&page=$page&pageSize=$pageSize';

    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchHouseInformation(String houseId) {
    String endpoint = '/houses/$houseId/rooms/';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchProvinces() {
    String endpoint = 'https://provinces.tmquang.com/api/?depth=3';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, notUseBaseUrl: true);
  }
}

import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class BillService {
  static Future<http.Response> fetchBillList({
    required String sort,
    String? filters,
    required int page,
    required String houseId,
    int pageSize = 10,
  }) {
    String endpoint = '/bills/$houseId/list?$filters$sort&page=$page&pageSize=$pageSize';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchBillDetail(String billId) {
    String endpoint = '/bills/$billId/details';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
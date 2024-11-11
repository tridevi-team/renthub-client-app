import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class BillService {
  static Future<http.Response> fetchBillList(String houseId) {
    String endpoint = '/bills/$houseId/list';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchBillDetail(String billId) {
    String endpoint = '/bills/$billId/details';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';


class CustomerService {
  static Future<http.Response> getCustomerInfo() async {
    String endpoint = '/renters/info';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
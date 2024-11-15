import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';


class CustomerService {
  static Future<http.Response> getCustomerInfo() async {
    String endpoint = '/renters/info';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

 /* static Future<http.Response> updateCustomerInfo(Map<String, dynamic> body) async {
    String endpoint = '/renters/info';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.put, auth: true, body: body);
  }*/

  static Future<http.Response> fetchRoomDetails({required String roomId}) async {
    String endpoint = '/rooms/$roomId/details';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
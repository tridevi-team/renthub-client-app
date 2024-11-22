import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';


class CustomerService {
  static Future<http.Response> getCustomerInfo() async {
    String endpoint = '/renters/info';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> updateCustomerInfo(String renterId, Map<String, dynamic> body) async {
    String endpoint = '/renters/$renterId/update';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.put, auth: true, params: body);
  }

  static Future<http.Response> fetchRoomDetails({required String roomId}) async {
    String endpoint = '/rooms/$roomId/details';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchRoomMembers({required String roomId}) async {
    String endpoint = '/renters/rooms/$roomId/search';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}
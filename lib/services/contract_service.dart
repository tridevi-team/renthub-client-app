import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class ContractService {

  static Future<http.Response> getAllContractInRoom({required String roomId}) async {
    String endpoint = '/contracts/$roomId/contracts';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> getContractDetail({required String contractId}) async {
    String endpoint = '/contracts/$contractId/contract-details';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> updateContractStatus({required String contractId, required Map<String, dynamic> body}) async {
    String endpoint = '/contracts/$contractId/update-contract-status';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.patch, auth: true, params: body);
  }
}
import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class HomeService {
  static Future<http.Response> fetchHouseList({
      String? keyword,
      int? numOfBeds,
      String? street,
      String? ward,
      String? district,
      String? city,
      int? numOfRenters,
      int? roomArea,
      int? priceFrom,
      int? priceTo,
      int limit = 20,
      int page = 1,
      String sortBy = "name",
      String orderBy = "asc"}) {

    Map<String, dynamic> queryParams = {
      'limit': limit.toString(),
      'page': page.toString(),
      'sortBy': sortBy,
      'orderBy': orderBy,
      if (keyword != null) 'keyword': keyword,
      if (numOfBeds != null) 'numOfBeds': numOfBeds.toString(),
      if (street != null) 'street': street,
      if (ward != null) 'ward': ward,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (numOfRenters != null) 'numOfRenters': numOfRenters.toString(),
      if (roomArea != null) 'roomArea': roomArea.toString(),
      if (priceFrom != null) 'priceFrom': priceFrom.toString(),
      if (priceTo != null) 'priceTo': priceTo.toString(),
    };

    String queryString = Uri(queryParameters: queryParams).query;

    String endpoint = '/houses/search/?$queryString';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchHouseInformation(String houseId) {
    String endpoint = '/houses/$houseId/rooms/';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }
}

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class IssueService {
  static Future<http.Response> createIssues({required String houseId, required Map<String, dynamic> body}) {
    String endpoint = '/issues/$houseId/create';
    return BaseService.requestApi(
      endpoint: endpoint,
      httpMethod: HttpMethod.post,
      auth: true,
      params: body,
    );
  }

  static Future<http.Response> fetchAllIssues({
    required String sort,
    String? filters,
    required int page,
    required String houseId,
    int pageSize = 10,
  }) {
    String endpoint = '/issues/$houseId/search?$filters$sort&page=$page&pageSize=$pageSize';

    return BaseService.requestApi(
      endpoint: endpoint,
      httpMethod: HttpMethod.get,
      auth: true,
    );
  }

  static Future<http.Response> fetchDetailIssue({required String issueId}) {
    String endpoint = '/issues/$issueId/details';
    return BaseService.requestApi(
      endpoint: endpoint,
      httpMethod: HttpMethod.get,
      auth: true,
    );
  }

  static Future<http.Response> uploadFiles(List<File> files, void Function(double progress)? onProgress) {
    String endpoint = '/uploads';
    return BaseService.requestApi(
      endpoint: endpoint,
      httpMethod: HttpMethod.multipart,
      auth: true,
      files: files,
      onProgress: onProgress
    );
  }
}

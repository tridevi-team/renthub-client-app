import 'dart:convert';

class ResponseErrorUtil {
  ResponseErrorUtil._();
  static String? handleErrorResponse(int statusCode, String responseBody) {
    if ([522, 408, 1000].contains(statusCode)) {
      return responseBody;
    }

    if (statusCode >= 300) {
      final decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      return decodedResponse["message"] ?? 'Unknown error';
    }

    return null;
  }
}

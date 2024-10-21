class ResponseModel<T> {
  bool? success;
  String? code;
  String? message;
  T? data;

  ResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  ResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) parseData) {
    success = json['success'] ?? false;
    code = json['code'] ?? '';
    message = json['message'] ?? '';
    data = json['data'] != null ? parseData(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data,
    };
  }
}

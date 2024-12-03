import 'package:rent_house/models/room_model.dart';

class BillModel {
  String? id;
  String? roomId;
  String? roomName;
  String? title;
  int? amount;
  String? startDate;
  String? endDate;
  String? paymentDate;
  String? status;
  String? description;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? createdAt;
  List<ServiceModel>? services;

  BillModel({
    this.id,
    this.roomId,
    this.roomName,
    this.title,
    this.amount,
    this.startDate,
    this.endDate,
    this.paymentDate,
    this.status,
    this.description,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.createdAt,
    this.services,
  });

  BillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    roomId = json['roomId'] ?? '';
    roomName = json['roomName'] ?? '';
    title = json['title'] ?? '';
    amount = json['amount'] ?? 0;
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    paymentDate = json['paymentDate'] ?? '';
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    accountName = json['accountName'] ?? '';
    accountNumber = json['accountNumber'] ?? '';
    bankName = json['bankName'] ?? '';
    createdAt = json['createdAt'] ?? '';
    services = (json['services'] as List<dynamic>?)?.map((service) => ServiceModel.fromJson(service as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'roomName': roomName,
      'title': title,
      'amount': amount,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'description': description,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'createdAt': createdAt,
    };
  }
}

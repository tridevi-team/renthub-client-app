class BillModel {
  String? id;
  String? roomId;
  String? roomName;
  String? title;
  int? amount;
  String? startDate;
  String? endDate;
  String? status;
  String? description;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? createdAt;

  BillModel({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.title,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.createdAt,
  });

  BillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    roomId = json['roomId'] ?? '';
    roomName = json['roomName'] ?? '';
    title = json['title'] ?? '';
    amount = json['amount'] ?? 0;
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    accountName = json['accountName'] ?? '';
    accountNumber = json['accountNumber'] ?? '';
    bankName = json['bankName'] ?? '';
    createdAt = json['createdAt'] ?? '';
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

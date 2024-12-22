import 'package:rent_house/models/address_model.dart';
import 'package:rent_house/models/room_model.dart';

class ContractModel {
  String? id;
  String? roomId;
  String? contractId;
  Landlord? landlord;
  Landlord? renter;
  String? renterIds;
  String? content;
  int? depositAmount;
  String? depositStatus;
  DateTime? depositDate;
  int? depositRefund;
  DateTime? depositRefundDate;
  DateTime? rentalStartDate;
  DateTime? rentalEndDate;
  Room? room;
  List<ServiceModel>? services;
  List<EquipmentModel>? equipment;
  String? status;
  String? approvalStatus;
  String? approvalNote;
  DateTime? approvalDate;
  String? approvalBy;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;

  ContractModel({
    this.id,
    this.roomId,
    this.contractId,
    this.landlord,
    this.renter,
    this.renterIds,
    this.content,
    this.depositAmount,
    this.depositStatus,
    this.depositDate,
    this.depositRefund,
    this.depositRefundDate,
    this.rentalStartDate,
    this.rentalEndDate,
    this.room,
    this.services,
    this.equipment,
    this.status,
    this.approvalStatus,
    this.approvalNote,
    this.approvalDate,
    this.approvalBy,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  ContractModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['roomId'];
    contractId = json['contractId'];
    landlord = json['landlord'] != null ? Landlord.fromJson(json['landlord']) : null;
    renter = json['renter'] != null ? Landlord.fromJson(json['renter']) : null;
    renterIds = json['renterIds'];
    content = json['content'];
    depositAmount = json['depositAmount'];
    depositStatus = json['depositStatus'];
    depositDate = json['depositDate'] != null ? DateTime.tryParse(json['depositDate']) : null;
    depositRefund = json['depositRefund'];
    depositRefundDate = json['depositRefundDate'] != null ? DateTime.tryParse(json['depositRefundDate']) : null;
    rentalStartDate = json['rentalStartDate'] != null ? DateTime.tryParse(json['rentalStartDate']) : null;
    rentalEndDate = json['rentalEndDate'] != null ? DateTime.tryParse(json['rentalEndDate']) : null;
    room = json['room'] != null ? Room.fromJson(json['room']) : null;
    services = json['services'] != null
        ? (json['services'] as List).map((item) => ServiceModel.fromJson(item)).toList()
        : [];
    equipment = json['equipment'] != null
        ? (json['equipment'] as List).map((item) => EquipmentModel.fromJson(item)).toList()
        : [];
    status = json['status'];
    approvalStatus = json['approvalStatus'];
    approvalNote = json['approvalNote'];
    approvalDate = json['approvalDate'] != null ? DateTime.tryParse(json['approvalDate']) : null;
    approvalBy = json['approvalBy'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null;
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'contractId': contractId,
      'landlord': landlord?.toJson(),
      'renter': renter?.toJson(),
      'renterIds': renterIds,
      'content': content,
      'depositAmount': depositAmount,
      'depositStatus': depositStatus,
      'depositDate': depositDate?.toIso8601String(),
      'depositRefund': depositRefund,
      'depositRefundDate': depositRefundDate?.toIso8601String(),
      'rentalStartDate': rentalStartDate?.toIso8601String(),
      'rentalEndDate': rentalEndDate?.toIso8601String(),
      'room': room,
      'services': services?.map((s) => s.toJson()).toList(),
      'equipment': equipment?.map((e) => e.toJson()).toList(),
      'status': status,
      'approvalStatus': approvalStatus,
      'approvalNote': approvalNote,
      'approvalDate': approvalDate?.toIso8601String(),
      'approvalBy': approvalBy,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Landlord {
  String? email;
  String? gender;
  Address? address;
  String? birthday;
  String? fullName;
  String? citizenId;
  String? phoneNumber;
  String? dateOfIssue;
  String? placeOfIssue;

  Landlord({
    this.email,
    this.gender,
    this.address,
    this.birthday,
    this.fullName,
    this.citizenId,
    this.phoneNumber,
    this.dateOfIssue,
    this.placeOfIssue,
  });

  Landlord.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    gender = json['gender'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    birthday = json['birthday'];
    fullName = json['fullName'] ?? json['full_name'];
    citizenId = json['citizenId'] ?? json['citizen_id'];
    phoneNumber = json['phoneNumber'] ?? json['phone_number'];
    dateOfIssue = json['dateOfIssue'] ?? json['date_of_issue'];
    placeOfIssue = json['placeOfIssue'] ?? json['place_of_issue'];
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'gender': gender,
      'address': address?.toJson(),
      'birthday': birthday,
      'fullName': fullName,
      'citizenId': citizenId,
      'phoneNumber': phoneNumber,
      'dateOfIssue': dateOfIssue,
      'placeOfIssue': placeOfIssue,
    };
  }
}






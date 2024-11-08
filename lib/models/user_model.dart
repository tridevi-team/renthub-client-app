import 'package:rent_house/models/address_model.dart';

class UserModel {
  String? id;
  String? roomId;
  String? name;
  String? citizenId;
  String? birthday;
  String? gender;
  String? email;
  String? phoneNumber;
  Address? address;
  int? tempReg;
  String? moveInDate;
  int? represent;
  String? note;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;


  UserModel({this.id,
    this.roomId,
    this.name,
    this.citizenId,
    this.birthday,
    this.gender,
    this.email,
    this.phoneNumber,
    this.address,
    this.tempReg,
    this.moveInDate,
    this.represent,
    this.note,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['roomId'];
    name = json['name'];
    citizenId = json['citizenId'];
    birthday = json['birthday'];
    gender = json['gender'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = Address.fromJson(json['address']);
    tempReg = json['tempReg'];
    moveInDate = json['moveInDate'];
    represent = json['represent'];
    note = json['note'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roomId'] = roomId;
    data['name'] = name;
    data['citizenId'] = citizenId;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['tempReg'] = tempReg;
    data['moveInDate'] = moveInDate;
    data['represent'] = represent;
    data['note'] = note;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class HouseModel {
  String? id;
  String? name;
  Address? address;
  String? description;
  int? collectionCycle;
  int? invoiceDate;
  int? numCollectDays;
  int? status;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;

  HouseModel({
    this.id,
    this.name,
    this.address,
    this.description,
    this.collectionCycle,
    this.invoiceDate,
    this.numCollectDays,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  HouseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    description = json['description'];
    collectionCycle = json['collectionCycle'];
    invoiceDate = json['invoiceDate'];
    numCollectDays = json['numCollectDays'];
    status = json['status'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address?.toJson(),
      'description': description,
      'collectionCycle': collectionCycle,
      'invoiceDate': invoiceDate,
      'numCollectDays': numCollectDays,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

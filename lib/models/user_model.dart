import 'package:rent_house/models/address_model.dart';

class UserModel {
  String? id;
  String? email;
  String? fullName;
  String? gender;
  String? phoneNumber;
  String? address;
  DateTime? birthday;
  String? role;
  String? type;
  int? status;
  int? verify;
  int? firstLogin;
  String? token;
  List<HouseModel>? houses;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.gender,
    this.phoneNumber,
    this.address,
    this.birthday,
    this.role,
    this.type,
    this.status,
    this.verify,
    this.firstLogin,
    this.token,
    this.houses,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    birthday = json['birthday'] != null ? DateTime.parse(json['birthday']) : null;
    role = json['role'];
    type = json['type'];
    status = json['status'];
    verify = json['verify'];
    firstLogin = json['firstLogin'];
    token = json['token'];
    if (json['houses'] != null) {
      houses = (json['houses'] as List)
          .map((e) => HouseModel.fromJson(e))
          .toList();
    } else {
      houses = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address, // Change this to address?.toJson() if using Address model
      'birthday': birthday?.toIso8601String(),
      'role': role,
      'type': type,
      'status': status,
      'verify': verify,
      'firstLogin': firstLogin,
      'token': token,
      'houses': houses?.map((house) => house.toJson()).toList(),
    };
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

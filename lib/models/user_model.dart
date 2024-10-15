import 'package:rent_house/models/address_model.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? gender;
  final String? phoneNumber;
  final String? address;
  final DateTime? birthday;
  final String? role;
  final String? type;
  final int? status;
  final int? verify;
  final int? firstLogin;
  final String? token;
  final List<HouseModel>? houses;

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      role: json['role'],
      type: json['type'],
      status: json['status'],
      verify: json['verify'],
      firstLogin: json['firstLogin'],
      token: json['token'],
      houses: json['houses'] != null
          ? (json['houses'] as List).map((e) => HouseModel.fromJson(e)).toList()
          : [],
    );
  }
}

class HouseModel {
  final String? id;
  final String? name;
  final Address? address;
  final String? description;
  final int? collectionCycle;
  final int? invoiceDate;
  final int? numCollectDays;
  final int? status;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

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

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'],
      name: json['name'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      description: json['description'],
      collectionCycle: json['collectionCycle'],
      invoiceDate: json['invoiceDate'],
      numCollectDays: json['numCollectDays'],
      status: json['status'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
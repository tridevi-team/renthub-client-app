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
  String? accessToken;
  String? refreshToken;

  UserModel({
    this.id,
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
    this.updatedAt,
    this.accessToken,
    this.refreshToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    roomId = json['roomId'] as String?;
    name = json['name'] as String?;
    citizenId = json['citizenId'] as String?;
    birthday = json['birthday'] as String?;
    gender = json['gender'] as String?;
    email = json['email'] as String?;
    phoneNumber = json['phoneNumber'] as String?;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    tempReg = json['tempReg'] as int?;
    moveInDate = json['moveInDate'] as String?;
    represent = json['represent'] as int?;
    note = json['note'] as String?;
    createdBy = json['createdBy'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedBy = json['updatedBy'] as String?;
    updatedAt = json['updatedAt'] as String?;
    accessToken = json['accessToken'] as String?;
    refreshToken = json['refreshToken'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'name': name,
      'citizenId': citizenId,
      'birthday': birthday,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address?.toJson(),
      'tempReg': tempReg,
      'moveInDate': moveInDate,
      'represent': represent,
      'note': note,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

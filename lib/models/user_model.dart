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
  String? houseId;
  String? floorId;

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
    this.houseId,
    this.floorId
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
    houseId = json['houseId'] as String?;
    floorId = json['floorId'] as String?;
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
      'houseId': houseId,
      'floorId': floorId,
    };
  }

  UserModel copyWith({
    String? id,
    String? roomId,
    String? name,
    String? citizenId,
    String? birthday,
    String? gender,
    String? email,
    String? phoneNumber,
    Address? address,
    int? tempReg,
    String? moveInDate,
    int? represent,
    String? note,
    String? createdBy,
    String? createdAt,
    String? updatedBy,
    String? updatedAt,
    String? accessToken,
    String? refreshToken,
    String? houseId,
    String? floorId,
  }) {
    return UserModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      citizenId: citizenId ?? this.citizenId,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      tempReg: tempReg ?? this.tempReg,
      moveInDate: moveInDate ?? this.moveInDate,
      represent: represent ?? this.represent,
      note: note ?? this.note,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      houseId: houseId ?? this.houseId,
      floorId: floorId ?? this.floorId,
    );
  }
}

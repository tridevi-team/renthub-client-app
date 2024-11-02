

import 'package:rent_house/models/address_model.dart';

class RenterModel {
  String? id;
  String? email;
  String? fullName;
  String? gender;
  String? phoneNumber;
  String? address;
  String? birthday;
  String? role;
  String? type;
  int? status;
  int? verify;
  int? firstLogin;
  String? token;
  List<Houses>? houses;

  RenterModel(
      {this.id,
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
        this.houses});

  RenterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    birthday = json['birthday'];
    role = json['role'];
    type = json['type'];
    status = json['status'];
    verify = json['verify'];
    firstLogin = json['firstLogin'];
    token = json['token'];
    if (json['houses'] != null) {
      houses = <Houses>[];
      json['houses'].forEach((v) {
        houses!.add(Houses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['birthday'] = birthday;
    data['role'] = role;
    data['type'] = type;
    data['status'] = status;
    data['verify'] = verify;
    data['firstLogin'] = firstLogin;
    data['token'] = token;
    if (houses != null) {
      data['houses'] = houses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Houses {
  String? id;
  String? name;
  Address? address;
  String? contractDefault;
  String? description;
  String? collectionCycle;
  String? invoiceDate;
  int? numCollectDays;
  bool? status;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  Permissions? permissions;

  Houses(
      {this.id,
        this.name,
        this.address,
        this.contractDefault,
        this.description,
        this.collectionCycle,
        this.invoiceDate,
        this.numCollectDays,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.permissions});

  Houses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    contractDefault = json['contractDefault'];
    description = json['description'];
    collectionCycle = json['collectionCycle'];
    invoiceDate = json['invoiceDate'];
    numCollectDays = json['numCollectDays'];
    status = json['status'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    permissions = json['permissions'] != null
        ? Permissions.fromJson(json['permissions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['contractDefault'] = contractDefault;
    data['description'] = description;
    data['collectionCycle'] = collectionCycle;
    data['invoiceDate'] = invoiceDate;
    data['numCollectDays'] = numCollectDays;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    if (permissions != null) {
      data['permissions'] = permissions!.toJson();
    }
    return data;
  }
}

class Permissions {
  House? house;
  House? role;
  House? room;
  House? renter;
  House? service;
  House? bill;
  House? equipment;
  House? payment;

  Permissions(
      {this.house,
        this.role,
        this.room,
        this.renter,
        this.service,
        this.bill,
        this.equipment,
        this.payment});

  Permissions.fromJson(Map<String, dynamic> json) {
    house = json['house'] != null ? House.fromJson(json['house']) : null;
    role = json['role'] != null ? House.fromJson(json['role']) : null;
    room = json['room'] != null ? House.fromJson(json['room']) : null;
    renter = json['renter'] != null ? House.fromJson(json['renter']) : null;
    service =
    json['service'] != null ? House.fromJson(json['service']) : null;
    bill = json['bill'] != null ? House.fromJson(json['bill']) : null;
    equipment = json['equipment'] != null
        ? House.fromJson(json['equipment'])
        : null;
    payment =
    json['payment'] != null ? House.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (house != null) {
      data['house'] = house!.toJson();
    }
    if (role != null) {
      data['role'] = role!.toJson();
    }
    if (room != null) {
      data['room'] = room!.toJson();
    }
    if (renter != null) {
      data['renter'] = renter!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (bill != null) {
      data['bill'] = bill!.toJson();
    }
    if (equipment != null) {
      data['equipment'] = equipment!.toJson();
    }
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    return data;
  }
}

class House {
  bool? create;
  bool? read;
  bool? update;
  bool? delete;

  House({this.create, this.read, this.update, this.delete});

  House.fromJson(Map<String, dynamic> json) {
    create = json['create'];
    read = json['read'];
    update = json['update'];
    delete = json['delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['create'] = create;
    data['read'] = read;
    data['update'] = update;
    data['delete'] = delete;
    return data;
  }
}
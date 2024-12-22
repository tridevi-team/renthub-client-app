import 'package:rent_house/models/address_model.dart';

class Room {
  String? id;
  String? name;
  int? price;
  int? area;
  int? maxRenters;
  String? status;
  String? description;
  List<ImageModel>? images;
  List<ServiceModel>? services;
  List<EquipmentModel>? equipments;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  _HouseModel? house;

  Room({
    this.id,
    this.name,
    this.price,
    this.area,
    this.maxRenters,
    this.status,
    this.description,
    this.images,
    this.services,
    this.house,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    area = json['roomArea'];
    maxRenters = json['maxRenters'];
    status = json['status'];
    description = json['description'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    house = json['house'] != null ? _HouseModel.fromJson(json['house']) : null;
    images = images = (json['images'] as List?)
            ?.map((i) {
              if (i is String) {
                return ImageModel(imageUrl: i);
              } else if (i is Map<String, dynamic>) {
                return ImageModel.fromJson(i);
              }
              return null;
            })
            .whereType<ImageModel>()
            .toList() ??
        [];
    equipments  = (json['equipment'] as List?)?.map((i) => EquipmentModel.fromJson(i)).toList() ?? [];
    services = (json['services'] as List?)?.map((i) => ServiceModel.fromJson(i)).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'roomArea': area,
      'maxRenters': maxRenters,
      'status': status,
      'description': description,
      'images': images?.map((image) => image.toJson()).toList(),
      'equipment': equipments?.map((equipment) => equipment.toJson()).toList(),
      'services': services?.map((service) => service.toJson()).toList(),
      'house': house?.toJson(),
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
    };
  }
}

class ImageModel {
  String? id;
  String? imageUrl;
  String? description;

  ImageModel({
    this.id,
    this.imageUrl,
    this.description,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}

class ServiceModel {
  String? id;
  String? name;
  int? unitPrice;
  String? description;
  String? type;
  int? quantity;
  int? oldValue;
  int? newValue;
  int? amount;
  int? totalPrice;

  ServiceModel({
    this.id,
    this.name,
    this.unitPrice,
    this.description,
    this.type,
    this.quantity,
    this.oldValue,
    this.newValue,
    this.amount,
    this.totalPrice,
  });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitPrice = json['unitPrice'] ?? json['unit_price'];
    description = json['description'];
    type = json['type'];
    quantity = json['quantity'];
    oldValue = json['oldValue'];
    newValue = json['newValue'];
    amount = json['amount'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitPrice': unitPrice,
      'description': description,
      'type': type,
      'quantity': quantity,
      'oldValue': oldValue,
      'newValue': newValue,
      'amount': amount,
      'totalPrice': totalPrice,
    };
  }
}

class EquipmentModel {
  String? id;
  String? houseId;
  String? floorId;
  String? roomId;
  String? code;
  String? name;
  String? status;
  String? sharedType;
  String? description;

  EquipmentModel({
    this.id,
    this.houseId,
    this.floorId,
    this.roomId,
    this.code,
    this.name,
    this.status,
    this.sharedType,
    this.description,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'],
      houseId: json['houseId'],
      floorId: json['floorId'],
      roomId: json['roomId'],
      code: json['code'],
      name: json['name'],
      status: json['status'],
      sharedType: json['sharedType'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseId': houseId,
      'floorId': floorId,
      'roomId': roomId,
      'code': code,
      'name': name,
      'status': status,
      'sharedType': sharedType,
      'description': description,
    };
  }
}


class _HouseModel {
  String? id;
  String? name;
  String? description;
  _FloorModel? floor;
  Address? address;

  _HouseModel();

  _HouseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    floor = json['floor'] != null ? _FloorModel.fromJson(json['floor']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'floor': floor?.toJson(),
    };
  }
}

class _FloorModel {
  String? id;
  String? name;
  String? description;

  _FloorModel();

  _FloorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

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
    images = (json['images'] as List?)?.map((i) => ImageModel.fromJson(i)).toList() ?? [];
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

  ServiceModel({
    this.id,
    this.name,
    this.unitPrice,
    this.description,
    this.type,
    this.quantity,
  });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitPrice = json['unitPrice'];
    description = json['description'];
    type = json['type'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitPrice': unitPrice,
      'description': description,
      'type': type,
      'quantity': quantity,
    };
  }
}

class _HouseModel {
  String? id;
  String? name;
  String? description;
  _FloorModel? floor;

  _HouseModel({
    this.id,
    this.name,
    this.description,
    this.floor,
  });

  _HouseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    floor = json['floor'] != null ? _FloorModel.fromJson(json['floor']) : null;
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

  _FloorModel({
    this.id,
    this.name,
    this.description,
  });

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

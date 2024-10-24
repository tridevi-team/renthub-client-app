class Room {
  String? id;
  String? name;
  int? price;
  int? area;
  int? maxRenters;
  String? status;
  String? description;
  List<ImageModel>? images;
  List<Service>? services;

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
  });

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    price = json['price'] ?? 0;
    area = json['roomArea'] ?? 0;
    maxRenters = json['maxRenters'] ?? 1;
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    images = (json['images'] as List?)?.map((i) => ImageModel.fromJson(i)).toList() ?? [];
    if (json['services'] != null) {
      services = (json['services'] as List)
          .map((i) => Service.fromJson(i))
          .toList();
    } else {
      services = [];
    }
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
    id = json['id'] ?? '';
    imageUrl = json['imageUrl'] ?? '';
    description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}

class Service {
  String? id;
  String? name;
  int? unitPrice;
  String? description;
  String? type;
  int? quantity;

  Service({
    required this.id,
    this.name,
    this.unitPrice,
    this.description,
    this.type,
    this.quantity,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
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

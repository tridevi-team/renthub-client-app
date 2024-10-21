class Room {
  String? id;
  String? name;
  int? price;
  int? area;
  int? maxRenters;
  String? status;
  String? description;
  List<String>? images;
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
    area = json['area'] ?? 0;
    maxRenters = json['maxRenters'] ?? 1;
    status = json['status'] ?? '';
    description = json['description'] ?? '';
    images = List<String>.from(json['images'] ?? []);
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
      'area': area,
      'maxRenters': maxRenters,
      'status': status,
      'description': description,
      'images': images,
      'services': services?.map((service) => service.toJson()).toList(),
    };
  }
}

class Service {
  String? id;
  String? name;
  int? price;
  String? description;

  Service({
    required this.id,
    this.name,
    this.price,
    this.description,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}

class Address {
  String? city;
  String? district;
  String? ward;
  String? street;

  Address({
    required this.city,
    required this.district,
    required this.ward,
    required this.street,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      street: json['street'] ?? '',
    );
  }
}
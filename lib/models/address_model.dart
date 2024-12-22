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

  Address.fromJson(Map<String, dynamic> json) {
      city = json['city'] ?? '';
      district = json['district'] ?? '';
      ward = json['ward'] ?? '';
      street = json['street'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'ward': ward,
      'street': street,
    };
  }

  @override
  String toString() {
    return "$street, $ward, $district, $city";
  }
}

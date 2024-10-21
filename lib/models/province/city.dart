import 'package:rent_house/models/province/district.dart';

class City {
  String? name;
  int? code;
  String? codename;
  String? divisionType;
  int? phoneCode;
  List<District>? districts;

  City({
    this.name,
    this.code,
    this.codename,
    this.divisionType,
    this.phoneCode,
    this.districts,
  });

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    codename = json['codename'];
    divisionType = json['division_type'];
    phoneCode = json['phone_code'];
    districts = (json['districts'] as List<dynamic>).map((district) => District.fromJson(district)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'codename': codename,
      'division_type': divisionType,
      'phone_code': phoneCode,
      'districts': districts?.map((district) => district.toJson()).toList(),
    };
  }
}

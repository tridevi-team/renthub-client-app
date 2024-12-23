import 'package:rent_house/models/province/city.dart';

class ProvinceSingleton {

  late List<City> _provinces = [];

  static final ProvinceSingleton instance = ProvinceSingleton._internal();
  factory ProvinceSingleton() => instance;

  ProvinceSingleton._internal();


  List<City> get provinces => _provinces;
  void setProvinces(List<City> provinces) => _provinces = provinces;

  bool get isProvincesEmpty => _provinces.isEmpty;
}
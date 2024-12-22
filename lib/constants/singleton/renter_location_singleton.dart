class RenterLocationSingleton {

  int? _cityId;
  int? _districtId;

  static final RenterLocationSingleton instance = RenterLocationSingleton._internal();
  factory RenterLocationSingleton() => instance;

  RenterLocationSingleton._internal();

  get cityId => _cityId;
  void setCityId(int cityId) {
    _cityId = cityId;
    _districtId = null;
  }

  get districtId => _districtId;
  void setDistrictId(int districtId) {
    _districtId = districtId;
  }
}
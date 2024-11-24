class ConstantString {
  ConstantString._();

  static const String prefFirstLogin = 'first_login';

  static const String prefAccessToken = 'pref_access_token';
  static const String prefRefreshToken = 'pref_refresh_token';
  static const String prefAppType = 'pref_app'; // dùng để phân biệt token của firebase hay của server
  static const String prefTypePhone = 'pref_type_phone';
  static const String prefTypeEmail = 'pref_type_email';
  static const String prefTypeServer = 'pref_type_server';
  static const String prefCity = 'pref_city';
  static const String prefDistrict = 'pref_district';

  static const String titleTempReg = "Đăng ký tạm trú";
  static const String descriptionTempReg = "Bạn xác nhận những thông tin này là đúng sự thật. Nếu có bất cứ vấn đề gì bạn sẽ phải chịu hoàn toàn mọi trách nhiệm?";
  static const String serviceTypeWater = 'WATER_CONSUMPTION';
  static const String serviceTypeElectric = 'ELECTRICITY_CONSUMPTION';
  static const String serviceTypeRoom = 'ROOM';
  static const String serviceTypePeople = 'PEOPLE';
  static const String statusMaintain = 'MAINTENANCE';
  static const String statusExpired = 'EXPIRED';
  static const String statusPending = 'PENDING';
  static const String statusAvailable = 'AVAILABLE';
}
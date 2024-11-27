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
  static const String statusRented = 'RENTED';

  //message
  static const String messageNoInternet = 'Không có kết nối mạng.';
  static const String messageNoData = 'Không có dữ liệu.';
  static const String dataInvalidMessage = 'Dữ liệu không hợp lệ';
  static const String messageSuccess = 'Thành công';
  static const String messageError = 'Lỗi';
  static const String messageWarning = 'Cảnh báo';
  static const String messageConfirm = 'Xác nhận';
  static const String loginRequiredMessage = "Bạn cần đăng nhập để sử dụng chức năng này.";
  static const String tryAgainMessage = "Có lỗi xảy ra. Vui lòng thử lại.";
  static const String restartAppMessage = "Có lỗi xảy ra. Vui lòng khởi động lại ứng dụng.";
  static const String sessionTimeoutMessage = "Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại.";
  static const String accountNotFoundMessage = "Tài khoản không tồn tại trong hệ thống. Vui lòng liên hệ với quản lý toà nhà.";
  static const String updateFailedMessage = "Cập nhật thông tin thất bại. Vui lòng thử lại.";
  static const String uploadFailedMessage = "Tải file lên thất bại. Vui lòng thử lại.";
}
class TokenSingleton{

  String? _accessToken;
  String? _refreshToken;

  static final TokenSingleton instance = TokenSingleton._internal();
  factory TokenSingleton() => instance;

  TokenSingleton._internal();

  get accessToken => _accessToken;
  void setAccessToken(String value) => _accessToken = value;

  get refreshToken => _refreshToken;
  void setRefreshToken(String value) => _refreshToken = value;

}
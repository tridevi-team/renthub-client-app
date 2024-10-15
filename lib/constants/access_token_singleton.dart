class AccessTokenSingleton{

  String? _token;

  static final AccessTokenSingleton instance = AccessTokenSingleton._internal();
  factory AccessTokenSingleton() => instance;

  AccessTokenSingleton._internal();

  get token => _token;
  void setToken(String value) => _token = value;

}
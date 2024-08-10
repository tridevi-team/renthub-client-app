class AccessTokenSingleton{

  String? token;

  static final AccessTokenSingleton instance = AccessTokenSingleton._internal();
  factory AccessTokenSingleton() => instance;

  AccessTokenSingleton._internal();

}
import 'package:rent_house/models/user_model.dart';

class UserSingleton{

  UserModel _user = UserModel();

  static final UserSingleton instance = UserSingleton._internal();
  factory UserSingleton() => instance;

  UserSingleton._internal();

  UserModel getUser() => _user;

  void setUser(UserModel value) => _user = value;
}
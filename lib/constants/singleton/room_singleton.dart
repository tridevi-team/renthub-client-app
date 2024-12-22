class RoomSingleton {

  String _roomName = "";
  String _houseName = "";

  static final RoomSingleton instance = RoomSingleton._internal();
  factory RoomSingleton() => instance;

  RoomSingleton._internal();

  String get roomName => _roomName;
  String get houseName => _houseName;

  void setRoomName(String value) => _roomName = value;
  void setHouseName(String value) => _houseName = value;

  void resetRoomName() => _roomName = "";
  void resetHouseName() => _houseName = "";

}
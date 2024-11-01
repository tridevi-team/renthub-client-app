import 'package:flutter/services.dart';

class NfcService {
  static const MethodChannel _channel = MethodChannel('nfc');

  Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> getCardUID() async {
    final String uid = await _channel.invokeMethod('getCardUID');
    return uid;
  }

  Future<String> getVersion(String commands) async {
    final String version = await _channel.invokeMethod('getVersion', {'commands': commands});
    return version;
  }
}

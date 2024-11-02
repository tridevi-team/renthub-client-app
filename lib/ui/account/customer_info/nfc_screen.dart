import 'package:flutter/material.dart';
import 'package:rent_house/services/nfc_service.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({super.key});

  @override
  _NfcScreenState createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  final NfcService _nfcService = NfcService();
  String _nfcData = 'NFC data will appear here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_nfcData),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCardUID,
              child: const Text('Get Card UID'),
            ),
            ElevatedButton(
              onPressed: () => _getVersion('YOUR_COMMANDS_HERE'),
              child: const Text('Get Version'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCardUID() async {
    try {
      final String uid = await _nfcService.getCardUID();
      setState(() {
        _nfcData = 'Card UID: $uid';
      });
    } catch (e) {
      setState(() {
        _nfcData = 'Error: $e';
      });
    }
  }

  Future<void> _getVersion(String commands) async {
    try {
      final String version = await _nfcService.getVersion(commands);
      setState(() {
        _nfcData = 'Version: $version';
      });
    } catch (e) {
      setState(() {
        _nfcData = 'Error: $e';
      });
    }
  }
}

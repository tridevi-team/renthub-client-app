import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFCScreen extends StatefulWidget {
  @override
  _NFCScreenState createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  String _nfcData = "No data";

  Future<void> _readNFC() async {
    try {
      final tag = await FlutterNfcKit.poll();
      final ndefRecords = await FlutterNfcKit.readNDEFRecords();
      final ndefData = ndefRecords.map((record) => record.payload).join(", ");
      setState(() {
        _nfcData = 'NFC Tag Found: ${tag.id}\nStandard: ${tag.standard}\nType: ${tag.type}\nNDEF Data: $ndefData';
      });

      await FlutterNfcKit.finish();
    } catch (e) {
      setState(() {
        _nfcData = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NFC Reader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _nfcData,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _readNFC,
              child: Text('Scan NFC Tag'),
            ),
          ],
        ),
      ),
    );
  }
}


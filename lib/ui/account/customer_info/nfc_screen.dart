import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFCReader extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NFCReader> {
  String nfcData = 'Scan an NFC tag';

  Future<void> _readNFC() async {
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      setState(() {
        nfcData = 'NFC Tag: ${tag.id}';
      });

      if (tag.ndefAvailable ?? false) {
        NFCTag ndefTag = (await FlutterNfcKit.readNDEFRecords()) as NFCTag;
        setState(() {
          nfcData = 'NFC NDEF: ${ndefTag.applicationData}';
        });
      }
    } catch (e) {
      setState(() {
        nfcData = 'Error: $e';
      });
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NFC Reader")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nfcData),
            const SizedBox(height: 20),
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

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:secrets/model/group.dart';
import 'package:secrets/service/db-helper.dart';

void main() => runApp(MaterialApp(home: ReadMessage()));

class ReadMessage extends StatefulWidget {
  // final Group group;
  const ReadMessage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReadMessageState();
}

class _ReadMessageState extends State<ReadMessage> {
  String _qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Message'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(),
            ),
          ),
          Text(_qrText)
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      List<String> parts = scanData.split('^');
      Group group = await dbHelper.get(parts.first);
      if (group != null) {
        setState(() {
          _qrText = group.decrypt(parts.last);
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
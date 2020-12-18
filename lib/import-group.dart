import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:secrets/model/group.dart';
import 'package:secrets/service/db-helper.dart';

void main() => runApp(MaterialApp(home: ImportGroup()));

class ImportGroup extends StatefulWidget {
  // final Group group;
  const ImportGroup({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImportGroupState();
}

class _ImportGroupState extends State<ImportGroup> {
  String _qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Group'),
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
      Group group = Group.fromFullCode(scanData);
      await dbHelper.insert(group);
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;


void main() => runApp(MaterialApp(home: ReadMessage()));

class ReadMessage extends StatefulWidget {
  final String groupKey;
  const ReadMessage({
    Key key,
    this.groupKey
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReadMessageState();
}

class _ReadMessageState extends State<ReadMessage> {
  String _qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
    final parts = widget.groupKey.split('^');
    final key = Encrypt.Key.fromBase64(parts[0]);
    final iv = Encrypt.IV.fromBase64(parts[1]);
    final encrypter = Encrypt.Encrypter(Encrypt.Salsa20(key));
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _qrText = encrypter.decrypt64(scanData, iv: iv);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
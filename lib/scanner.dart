import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pager2/new-contact.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  var qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8),
                    child: RaisedButton(
                      onPressed: goToNewContact,
                      child: Text("Enter Manually"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                      Text("Cancel"),
                    ),
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      goToNewContact(qrCode: scanData);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void goToNewContact({String qrCode}) {
    final completer = Completer();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return NewContact(qrCode: qrCode);
          }, // ...to here.
        ),
        result: completer.future
    ).then((value) {
      completer.complete(value);
    });
  }
}
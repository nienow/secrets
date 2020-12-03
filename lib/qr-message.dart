import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;

class QrMessage extends StatefulWidget {
  final String message;
  QrMessage({ Key key, this.message }): super(key: key);

  @override
  _QrMessageState createState() => _QrMessageState();
}

class _QrMessageState extends State<QrMessage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Secret Message'),
        ),
        body: buildBody()
    );
  }

  Widget buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QrImage(
              data: getEncryptedMessage(),
              version: QrVersions.auto
          )
        ]
    );
  }
  
  String getEncryptedMessage() {
    final key = Encrypt.Key.fromLength(32);
    final iv = Encrypt.IV.fromLength(8);
    final encrypter = Encrypt.Encrypter(Encrypt.Salsa20(key));
    return encrypter.encrypt(widget.message, iv: iv).base64;
  }

}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class QrMessage extends StatefulWidget {
  final String message;
  final String groupKey;
  QrMessage({ Key key, this.message, this.groupKey }): super(key: key);

  @override
  _QrMessageState createState() => _QrMessageState();
}

class _QrMessageState extends State<QrMessage> {
  // GlobalKey globalKey = new GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  String _encryptedMessage;

  void initState() {
    super.initState();
    _encryptedMessage = getEncryptedMessage();
    print(_encryptedMessage);
  }

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
        Screenshot(
          controller: screenshotController,
          child: QrImage(
              data: _encryptedMessage,
              version: QrVersions.auto
          )
        ),
        RaisedButton(
            onPressed: _copy,
            child: Text('Copy to Clipboard')
        ),
        RaisedButton(
            onPressed: _captureScreenshot,
            child: Text('Print')
        )
      ]
    );
  }

  void _copy() {
    FlutterClipboard.copy(_encryptedMessage).then(( value ) => print('copied'));
  }
  
  String getEncryptedMessage() {
    final parts = widget.groupKey.split('^');
    final key = Encrypt.Key.fromBase64(parts[0]);
    final iv = Encrypt.IV.fromBase64(parts[1]);
    final encrypter = Encrypt.Encrypter(Encrypt.Salsa20(key));
    return encrypter.encrypt(widget.message, iv: iv).base64;
  }

  _captureScreenshot() {
    screenshotController.capture().then((File image) {
      Share.shareFiles([image.path]);
    }).catchError((onError) {
      print(onError);
    });
  }

  // Future<void> _captureAndSharePng() async {
  //   try {
  //     RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
  //     var image = await boundary.toImage();
  //     ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  //     Uint8List pngBytes = byteData.buffer.asUint8List();
  //
  //     final tempDir = await getTemporaryDirectory();
  //     final file = await new File('${tempDir.path}/image.png').create();
  //     await file.writeAsBytes(pngBytes);
  //
  //     final channel = const MethodChannel('channel:me.alfian.share/share');
  //     channel.invokeMethod('shareFile', 'image.png');
  //
  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }

}

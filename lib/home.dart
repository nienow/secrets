import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secrets/box-button.dart';
import 'package:secrets/display-message.dart';
import 'package:secrets/manual-input.dart';
import 'package:secrets/read-message.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secrets')
      ),
      body: Container( 
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              child: Text('Read Message', style: Theme.of(context).textTheme.headline6)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BoxButton(text: 'Scan QR', icon: Icons.camera, onPressed: _scan),
                BoxButton(text: 'Paste Message', icon: Icons.paste, onPressed: _paste),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(5.0),
              child: Text('Create Message', style: Theme.of(context).textTheme.headline6)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BoxButton(text: 'Create QR', icon: Icons.qr_code, onPressed: _manual),
                BoxButton(text: 'Create Text', icon: Icons.copy, onPressed: _paste),
              ],
            )
          ]
        )
      )
    );
  }

  void _scan() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ReadMessage();
        },
      ),
    );
  }

  void _manual() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ManualInput();
        },
      ),
    );
  }

  void _paste() async {
    String paste = await FlutterClipboard.paste();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return DisplayMessage(message: paste);
        },
      )
    );
  }
}

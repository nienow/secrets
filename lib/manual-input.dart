import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pager2/qr-message.dart';
import 'package:pager2/service/key-service.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;


class ManualInput extends StatefulWidget {
  final String groupKey;
  ManualInput({ Key key, this.groupKey }): super(key: key);

  @override
  _ManualInputState createState() => _ManualInputState();
}

class _ManualInputState extends State<ManualInput> {
  final keyService = KeyService.instance;
  TextEditingController _inputFieldController;
  String _plainText = '';

  void initState() {
    super.initState();
    _inputFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Secret Message'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextField(
                  controller: _inputFieldController,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message'
                  ),
                ),
                RaisedButton(
                    onPressed: _submit,
                    child: Text('Read Message')
                ),
                Text(_plainText)
              ]
          ),
        )
    );
  }

  _submit() async {
    final parts = widget.groupKey.split('^');
    final key = Encrypt.Key.fromBase64(parts[0]);
    final iv = Encrypt.IV.fromBase64(parts[1]);
    final encrypter = Encrypt.Encrypter(Encrypt.Salsa20(key));

    setState(() {
      _plainText = encrypter.decrypt64(_inputFieldController.text, iv: iv);
    });
  }

  @override
  void dispose() {
    _inputFieldController?.dispose();
    super.dispose();
  }
}

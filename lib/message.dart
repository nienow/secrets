import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pager2/qr-message.dart';

class SecretMessage extends StatefulWidget {
  @override
  _SecretMessageState createState() => _SecretMessageState();
}

class _SecretMessageState extends State<SecretMessage> {
  TextEditingController _messageFieldController;

  void initState() {
    super.initState();
    _messageFieldController = TextEditingController();
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
                  controller: _messageFieldController,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message'
                  ),
                ),
                RaisedButton(
                    onPressed: _submit,
                    child: Text('Create Message')
                )
              ]
          ),
        )
    );
  }

  _submit() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return QrMessage(message: _messageFieldController.text);
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageFieldController?.dispose();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secrets/model/group.dart';
import 'package:secrets/service/db-helper.dart';


class DisplayMessage extends StatefulWidget {
  final String message;
  DisplayMessage({Key key, this.message}): super(key: key);

  @override
  _DisplayMessageState createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  final dbHelper = DatabaseHelper.instance;
  String decrypted = '';
  int timeLeft = 10;

  void initState() {
    super.initState();
    _decryptMessage();
  }

  _decryptMessage() async {
    List<String> parts = widget.message.split('^');
    if (parts.length == 2) {
      Group group = await dbHelper.get(parts.first);
      if (group != null) {
        setState(() {
          decrypted = group.decrypt(parts.last);
        });
      }
    }

    Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft -= 1;
      });
      if (timeLeft == 0) {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Message from: '),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(decrypted),
              Text('Message will auto close in ' + timeLeft.toString() + ' seconds')
            ],
          )
        )
    );
  }
}

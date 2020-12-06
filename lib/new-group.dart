import 'dart:async';

import 'package:flutter/material.dart';
import 'file:///C:/dev/other/pager2/lib/service/db-helper.dart';
import 'package:pager2/qr-connect.dart';
import 'package:pager2/service/key-service.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final dbHelper = DatabaseHelper.instance;
  final keyService = KeyService.instance;
  TextEditingController _nameFieldController;

  void initState() {
    super.initState();
    _nameFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Group'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextField(
              controller: _nameFieldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name'
              ),
            ),
            RaisedButton(
              onPressed: _submit,
              child: Text('Add')
            )
          ]
        ),
      )
    );
  }

  _submit() async {
    final key = keyService.generateKey();
    await dbHelper.insert({
      DatabaseHelper.columnName: _nameFieldController.text,
      DatabaseHelper.columnCode: key
    });
    final completer = Completer();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return GroupQr(groupKey: key + '^' + _nameFieldController.text);
        },
      ),
      result: completer.future
    );
    completer.complete();
  }

  @override
  void dispose() {
    _nameFieldController?.dispose();
    super.dispose();
  }
}
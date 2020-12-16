import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secrets/model/group.dart';
import 'package:secrets/qr-connect.dart';
import 'package:secrets/service/db-helper.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final dbHelper = DatabaseHelper.instance;
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
    final group = Group.newGroup(_nameFieldController.text);
    await dbHelper.insert(group);
    final completer = Completer();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return GroupQr(group: group);
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
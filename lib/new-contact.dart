import 'package:flutter/material.dart';
import 'package:pager2/db/db-helper.dart';

class NewContact extends StatefulWidget {
  final String qrCode;
  NewContact({ Key key, this.qrCode }): super(key: key);

  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final dbHelper = DatabaseHelper.instance;
  TextEditingController _idFieldController;
  TextEditingController _nameFieldController;

  void initState() {
    super.initState();
    if (this.widget.qrCode != null) {
      final qrCodeParts = this.widget.qrCode.split('+');
      _idFieldController = TextEditingController(text: qrCodeParts[0]);
      _nameFieldController = TextEditingController(text: qrCodeParts[1]);
    } else {
      _idFieldController = TextEditingController();
      _nameFieldController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _idFieldController,
                enabled: this.widget.qrCode == null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone ID',
                ),
              ),
            ),
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
    await dbHelper.insert({
      DatabaseHelper.columnId: _idFieldController.text,
      DatabaseHelper.columnName: _nameFieldController.text
    });
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _idFieldController?.dispose();
    _nameFieldController?.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secrets/model/group.dart';
import 'package:secrets/service/db-helper.dart';


class ManualInput extends StatefulWidget {
  @override
  _ManualInputState createState() => _ManualInputState();
}

class _ManualInputState extends State<ManualInput> {
  final dbHelper = DatabaseHelper.instance;
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
    List<String> parts = _inputFieldController.text.split('^');
    Group group = await dbHelper.get(parts.first);
    if (group != null) {
      setState(() {
        _plainText = group.decrypt(parts.last);
      });
    }
  }

  @override
  void dispose() {
    _inputFieldController?.dispose();
    super.dispose();
  }
}

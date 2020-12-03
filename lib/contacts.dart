import 'package:flutter/material.dart';
import 'package:pager2/db/db-helper.dart';
import 'package:pager2/message.dart';
import 'package:pager2/new-group.dart';
import 'package:pager2/scanner.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: _buildSuggestions(),
      floatingActionButton: FloatingActionButton(
        onPressed: _newContact,
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ),
    );
  }

  void _newContact() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // return QRViewExample();
          return NewGroup();
        },
      ),
    ).then((dynamic value) {
      if (value is bool && value) {
        setState(() {});
      }
    });
  }

  Future<void> _onMenu(String value, String itemName) async {
    if (value == 'delete') {
      await dbHelper.delete(itemName);
      setState(() {});
    } else if (value == 'message') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return SecretMessage();
          },
        ),
      );
    }
  }

  Widget _buildSuggestions() {
    return FutureBuilder<List>(
      future: dbHelper.queryAllRows(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            padding: EdgeInsets.all(16.0),
            itemCount: snapshot.data.length,
            itemBuilder: /*1*/ (context, i) {
              return ListTile(
                title: Text(snapshot.data[i][DatabaseHelper.columnName]),
                trailing: PopupMenuButton(
                  onSelected: (String value) {
                    _onMenu(value, snapshot.data[i][DatabaseHelper.columnName]);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'message',
                        child: Text('Message'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    ];
                  },
                ),
              );
            });
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}

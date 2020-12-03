import 'package:flutter/material.dart';
import 'package:pager2/db/db-helper.dart';
import 'package:pager2/message.dart';
import 'package:pager2/new-group.dart';
import 'package:pager2/qr-connect.dart';

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

  void _newContact() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // return QRViewExample();
          return NewGroup();
        },
      ),
    );
    setState(() {});
  }

  Future<void> _onMenu(String value, Map<String, dynamic> item) async {
    if (value == 'delete') {
      await dbHelper.delete(item[DatabaseHelper.columnName]);
      setState(() {});
    } else if (value == 'message') {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return SecretMessage();
          },
        ),
      );
      setState(() {});
    } else if (value == 'view') {
      final String key = item[DatabaseHelper.columnCode] + '^' + item[DatabaseHelper.columnName];
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return GroupQr(groupKey: key);
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
                    _onMenu(value, snapshot.data[i]);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'message',
                        child: Text('Message'),
                      ),
                      PopupMenuItem(
                        value: 'view',
                        child: Text('View Code'),
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

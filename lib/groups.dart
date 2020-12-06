import 'package:flutter/material.dart';
import 'file:///C:/dev/other/pager2/lib/service/db-helper.dart';
import 'package:pager2/manual-input.dart';
import 'package:pager2/message.dart';
import 'package:pager2/new-group.dart';
import 'package:pager2/qr-connect.dart';
import 'package:pager2/read-message.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: _buildSuggestions(),
      floatingActionButton: FloatingActionButton(
        onPressed: _newGroup,
        tooltip: 'Add Group',
        child: Icon(Icons.add),
      ),
    );
  }

  void _newGroup() async {
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

  void _newMessage(Map<String, dynamic> item) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SecretMessage(groupKey: item[DatabaseHelper.columnCode]);
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
            return SecretMessage(groupKey: item[DatabaseHelper.columnCode]);
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
    } else if (value == 'read') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return ReadMessage(groupKey: item[DatabaseHelper.columnCode]);
          },
        ),
      );
    } else if (value == 'manual') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return ManualInput(groupKey: item[DatabaseHelper.columnCode]);
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
                onTap: () {_newMessage(snapshot.data[i]);},
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
                        value: 'read',
                        child: Text('Read QR'),
                      ),
                      PopupMenuItem(
                        value: 'manual',
                        child: Text('Read Code'),
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

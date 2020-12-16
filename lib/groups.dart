import 'package:flutter/material.dart';
import 'package:secrets/message.dart';
import 'package:secrets/model/group.dart';
import 'package:secrets/new-group.dart';
import 'package:secrets/qr-connect.dart';
import 'package:secrets/service/db-helper.dart';

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

  void _newMessage(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SecretMessage(group: group);
        },
      ),
    );
    setState(() {});
  }

  Future<void> _onMenu(String value, Group group) async {
    if (value == 'delete') {
      await dbHelper.delete(group);
      setState(() {});
    } else if (value == 'message') {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return SecretMessage(group: group);
          },
        ),
      );
      setState(() {});
    } else if (value == 'view') {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return GroupQr(group: group);
          },
        ),
      );
    }
    // else if (value == 'read') {
    //   Navigator.of(context).push(
    //     MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return ReadMessage();
    //       },
    //     ),
    //   );
    // } else if (value == 'manual') {
    //   Navigator.of(context).push(
    //     MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return ManualInput();
    //       },
    //     ),
    //   );
    // }
  }

  Widget _buildSuggestions() {
    return FutureBuilder<List<Group>>(
      future: dbHelper.queryAllRows(),
      builder: (context, AsyncSnapshot<List<Group>> snapshot) {
        print(snapshot.hasData);
        print(snapshot.error);
        print(snapshot.data);
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            padding: EdgeInsets.all(16.0),
            itemCount: snapshot.data.length,
            itemBuilder: /*1*/ (context, i) {
              return ListTile(
                title: Text(snapshot.data[i].name),
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
                      // PopupMenuItem(
                      //   value: 'read',
                      //   child: Text('Read QR'),
                      // ),
                      // PopupMenuItem(
                      //   value: 'manual',
                      //   child: Text('Read Code'),
                      // ),
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

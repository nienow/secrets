import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:secrets/service/db-helper.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: _buildContacts()
    );
  }

  void _newMessage(Contact group) async {
    if (group.phones.isNotEmpty) {
      launch('sms:' + group.phones.first.value + '?body=goodbye');
    }
  }

  Widget _buildContacts() {
    return FutureBuilder<Iterable<Contact>>(
      future: ContactsService.getContacts(),
      builder: (context, AsyncSnapshot<Iterable<Contact>> snapshot) {
        if (snapshot.hasData) {
          final list = snapshot.data.toList();
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            padding: EdgeInsets.all(16.0),
            itemCount: snapshot.data.length,
            itemBuilder: /*1*/ (context, i) {
              return ListTile(
                title: Text(list[i].displayName),
                onTap: () {_newMessage(list[i]);}
              );
            });
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}

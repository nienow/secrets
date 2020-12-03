import 'package:flutter/material.dart';
import 'package:pager2/contacts.dart';
import 'package:pager2/qr-connect.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _seeItems() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Contacts();
        }, // ...to here.
      ),
    );
  }

  // void _showCode() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(
  //       builder: (BuildContext context) {
  //         return QrCode();
  //       }, // ...to here.
  //     ),
  //   );
  // }

  void _alert() {
    // do something
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: _alert,
              icon: Icon(Icons.escalator_warning, color: Colors.red)
            ),
            RaisedButton(
                onPressed: _seeItems,
                child: Text('See Contacts')
            ),
            // RaisedButton(
            //     onPressed: _showCode,
            //     child: Text('Show My Code')
            // )
          ],
        ),
      ),
    );
  }
}
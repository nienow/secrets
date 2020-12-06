import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pager2/groups.dart';
import 'package:pager2/model/group.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _tapBottom,
        items: [
          BottomNavigationBarItem(label: 'Scan', icon: Icon(Icons.camera)),
          BottomNavigationBarItem(label: 'Send', icon: Icon(Icons.send)),
          BottomNavigationBarItem(label: 'Groups', icon: Icon(Icons.group))
      ])
    );
  }

  _tapBottom(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildBody() {
    switch (_selectedIndex) {
      case 0:
      case 1:
      case 2:
        return Groups();
    }
    return Text('');
  }
}

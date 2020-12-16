import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secrets/groups.dart';
import 'package:secrets/home.dart';

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _tapBottom,
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          // BottomNavigationBarItem(label: 'Contacts', icon: Icon(Icons.send)),
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
        return HomeWidget();
      // case 1:
      //   return Contacts();
      case 1:
        return Groups();
    }
    return Text('');
  }
}

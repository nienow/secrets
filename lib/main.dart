import 'package:flutter/material.dart';
import 'package:pager2/groups.dart';
import 'package:pager2/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData.light();
    return MaterialApp(
      title: 'Secrets',
      theme: base.copyWith(
        primaryColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: base.buttonTheme.copyWith(
          buttonColor: Colors.red,
          textTheme: ButtonTextTheme.primary
        ),
        textTheme: base.textTheme.copyWith(
          button: base.textTheme.button.copyWith(
            color: Colors.white
          )
        )
      ),
      // theme: base,
      home: Home()
    );
  }


}
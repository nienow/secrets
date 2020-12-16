import 'package:flutter/material.dart';

class BoxButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  BoxButton({ Key key, this.onPressed, this.text, this.icon }): super(key: key);

  @override
  _BoxButtonState createState() => _BoxButtonState();
}

class _BoxButtonState extends State<BoxButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),
        child:  FlatButton(
          onPressed: widget.onPressed,
          child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(widget.icon),
              Text(widget.text)
            ],
          )
        )
      )
    );
  }
}

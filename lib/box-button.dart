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
            color: Colors.white,
            // border: Border.all(color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
        ),
        child:  FlatButton(
          onPressed: widget.onPressed,
          child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(widget.icon),
              SizedBox(height: 5),
              Text(widget.text)
            ],
          )
        )
      )
    );
  }
}

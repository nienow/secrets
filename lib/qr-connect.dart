
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:secrets/model/group.dart';

class GroupQr extends StatefulWidget {
  final Group group;
  GroupQr({ Key key, this.group }): super(key: key);

  @override
  _GroupQrState createState() => _GroupQrState();
}

class _GroupQrState extends State<GroupQr> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Code'),
        ),
        body: buildBody()
    );
  }

  Widget buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QrImage(
              data: widget.group.getFullCode(),
              version: QrVersions.auto
          ),
          Text(widget.group.getFullCode())
        ]
    );
  }

}

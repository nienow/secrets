import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pager2/service/key-service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GroupQr extends StatefulWidget {
  final String groupKey;
  GroupQr({ Key key, this.groupKey }): super(key: key);

  @override
  _GroupQrState createState() => _GroupQrState();
}

class _GroupQrState extends State<GroupQr> {
  final keyService = KeyService.instance;

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
              data: widget.groupKey,
              version: QrVersions.auto
          ),
          Text(widget.groupKey)
        ]
    );
  }

}

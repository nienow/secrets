import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pager2/service/key-service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GroupQr extends StatefulWidget {
  final String groupKey;
  GroupQr({ Key key, this.groupKey }): super(key: key);

  @override
  _GroupQrState createState() => _GroupQrState();
}

class _GroupQrState extends State<GroupQr> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
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
  
  // Future<void> initPlatformState() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       final androidData = await deviceInfoPlugin.androidInfo;
  //       setState(() {
  //         _deviceId = androidData.androidId;
  //         _deviceName = androidData.manufacturer + ' ' +androidData.device;
  //       });
  //     } else if (Platform.isIOS) {
  //       final isoData = await deviceInfoPlugin.iosInfo;
  //       setState(() {
  //         _deviceId = isoData.identifierForVendor;
  //         _deviceName = isoData.name;
  //       });
  //     }
  //   } on PlatformException {
  //     // fail
  //   }
  // }

}

import 'package:demo_jitsi/Page/Setting/components/body.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'จัดการการตั้งค่า',
            style: kHeadingTextStyle,
          ),
        ],
      ),
      leading: new TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ปิด')),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
          child: Container(
            color: Colors.grey[400],
            height: 0.3,
          ),
          preferredSize: Size.fromHeight(.0)),
    );
  }
}

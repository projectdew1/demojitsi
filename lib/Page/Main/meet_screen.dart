import 'package:demo_jitsi/Page/Main/index.dart';
import 'package:flutter/material.dart';

class MeetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Main(),
      appBar: buildAppBar(context),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              iconSize: 24,
              icon: Icon(Icons.settings_outlined),
              color: Colors.grey,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pushNamed(context, '/settingscreen');
              },
              tooltip: 'ตั้งค่า',
            ),
            IconButton(
              iconSize: 24,
              icon: Icon(Icons.add_call),
              color: Colors.deepOrange[300],
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pushNamed(context, '/createscreen');
              },
              tooltip: 'สร้างห้อง',
            ),
          ]),
    );
  }
}

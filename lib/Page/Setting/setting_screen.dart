import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Page/Setting/components/body.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> CheckServer() async {
    // print(_server.text[_server.text.length - 1]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String server =  prefs.getString(SERVER_JITSI);
    if (server != null){
    if (server.indexOf("/") == 0) {
      await EasyLoading.showError('Default Server ไม่ถูกต้อง');
      return;
    }
    }

    Navigator.pop(context);
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
            CheckServer();
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

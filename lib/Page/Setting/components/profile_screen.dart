import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Config/provider.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './body_profile.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;

  ProfileScreen({this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: buildAppBar(context),
        body: BodyProfile(name: name, email: email));
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
            'จัดการโปรไฟล์',
            style: kHeadingTextStyle,
          ),
        ],
      ),
      leading: new BackButton(color: kTextColor),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            final nameTrim = name.text.trim();
            final emailTrim = email.text.trim();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(EMAIL_JITSI, emailTrim);
            prefs.setString(NAME_JITSI, nameTrim);
            Provider.of<Person>(context, listen: false).setEmail(emailTrim);
            Provider.of<Person>(context, listen: false).setName(nameTrim);
            Navigator.pop(context);
          },
          child: Text('บันทึก'),
        )
      ],
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

import 'package:demo_jitsi/components/text_field_box.dart';
import 'package:flutter/material.dart';

class BodyProfile extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;

  BodyProfile({Key key, this.name, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height * 0.04),
            TextFieldBox(
              controller: name,
              titleText: 'ชื่อผู้ใช้',
              hintText: 'กรอกชื่อผู้ใช้',
            ),
            SizedBox(height: size.height * 0.04),
            TextFieldBox(
              controller: email,
              titleText: 'อีเมล',
              hintText: 'กรอกอีเมล',
            ),
          ]),
    );
  }
}

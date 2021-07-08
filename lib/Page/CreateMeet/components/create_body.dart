// import 'package:demo_jitsi/components/custom_switch.dart';
import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/components/list_container.dart';
import 'package:demo_jitsi/components/text_field_box.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateMeetBody extends StatefulWidget {
  final TextEditingController room;
  final TextEditingController name;
  final TextEditingController email;

  const CreateMeetBody({Key key, this.room, this.name, this.email})
      : super(key: key);

  @override
  _CreateMeetBodyState createState() => _CreateMeetBodyState();
}

class _CreateMeetBodyState extends State<CreateMeetBody> {
  bool isSwitched = false;
  bool isSwitched2 = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        SizedBox(height: size.height * 0.04),
        TextFieldBox(
          titleText: 'ชื่อห้องประชุม',
          hintText: 'กรอกชื่อห้องประชุม',
          controller: widget.room,
        ),
        SizedBox(height: size.height * 0.02),
        TextFieldBox(
          titleText: 'ชื่อผู้ใช้',
          hintText: 'กรอกชื่อผู้ใช้',
          controller: widget.name,
        ),
        SizedBox(height: size.height * 0.02),
        TextFieldBox(
          titleText: 'อีเมล',
          hintText: 'กรอกอีเมล',
          controller: widget.email,
        ),
        SizedBox(height: size.height * 0.04),

        // Mute on Entry
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('ห้องประชุม',
              style: TextStyle(
                  fontSize: 14,
                  // color: kTextColor,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: size.height * 0.015),
        ListContainer(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ปิดเสียงเมื่อเข้าห้องประชุม',
                      style: TextStyle(fontSize: 15),
                    ),
                    Switch(
                        value: isSwitched,
                        onChanged: (value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            isSwitched = value;
                            prefs.setBool(AUDIO_MUTE_JITSI_C, value);
                            print(isSwitched);
                          });
                        })
                  ])),
          Container(
              margin: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.grey),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ปิดวิดีโอเมื่อเข้าห้องประชุม',
                        style: TextStyle(fontSize: 15)),
                    Switch(
                        value: isSwitched2,
                        onChanged: (value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            prefs.setBool(VIDEO_MUTE_JITSI_C, value);
                            isSwitched2 = value;
                            print(isSwitched2);
                          });
                        })
                  ]))
        ]))
      ]),
    );
  }
}

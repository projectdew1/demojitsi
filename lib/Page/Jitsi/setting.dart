import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Config/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final name = TextEditingController();
  final email = TextEditingController();
  bool isAudioMuted = false;
  bool isVideoMuted = false;

  Future<void> setText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name.text = prefs.getString(NAME_JITSI);
      email.text = prefs.getString(EMAIL_JITSI);
      isAudioMuted = prefs.getBool(AUDIO_MUTE_JITSI);
      isVideoMuted = prefs.getBool(VIDEO_MUTE_JITSI);
    });
  }

  @override
  void initState() {
    super.initState();
    setText();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor: Color(0xFF031811),
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'โปรไฟล์',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Text(
                'ชื่อ',
              ),
              TextField(
                // focusNode: _focusNode,
                controller: name,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5),
                ),
                onChanged: (value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (value.trim() != "") {
                    prefs.setString(NAME_JITSI, value);
                    Provider.of<Person>(context, listen: false).setName(value);
                  }
                },
              ),
              SizedBox(height: 10),
              Text(
                'อีเมลล์',
              ),
              TextField(
                // focusNode: _focusNode,
                controller: email,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5),
                ),
                onChanged: (value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(EMAIL_JITSI, value);
                },
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Text(
                'ประชุม',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('ปิดเสียงเมื่อเริ่มประชุม'),
                  Switch(
                    value: isAudioMuted,
                    onChanged: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool(AUDIO_MUTE_JITSI, value);
                      setState(() {
                        isAudioMuted = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('ปิดวีดีโอเมื่อเริ่มประชุม'),
                  Switch(
                    value: isVideoMuted,
                    onChanged: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool(VIDEO_MUTE_JITSI, value);
                      setState(() {
                        isVideoMuted = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

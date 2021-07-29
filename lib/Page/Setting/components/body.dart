import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Config/provider.dart';
// import 'package:demo_jitsi/components/custom_switch.dart';
import 'package:demo_jitsi/components/list_container.dart';
import 'package:demo_jitsi/components/text_field_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import './profile_screen.dart';

class Body extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Body> {
  bool isSwitched = false;
  bool isSwitched2 = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final TextEditingController _server = TextEditingController();
  final _focusNode = FocusNode();

  Future<void> setText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name.text = prefs.getString(NAME_JITSI) ?? "";
      email.text = prefs.getString(EMAIL_JITSI) ?? "";
      _server.text = prefs.getString(SERVER_JITSI) ?? defaultServer;
      isSwitched = prefs.getBool(AUDIO_MUTE_JITSI) ?? false;
      isSwitched2 = prefs.getBool(VIDEO_MUTE_JITSI) ?? false;
    });
  }

  Future<void> CheckServer(focus) async {
    // print(_server.text[_server.text.length - 1]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String server = _server.text;
    String https = "https://";
    String http = "http://";
    String check = https + server;
    if (focus == false && server != "") {
      if (server.indexOf("/") == 0) {
        await EasyLoading.showError('Default Server ไม่ถูกต้อง');
        return;
      }

      if (server.indexOf(https) >= 0 || server.indexOf(http) >= 0) {
        setState(() {
          _server.text =
              server[server.length - 1] == "/" ? server : server + "/";
          prefs.setString(SERVER_JITSI,
              server[server.length - 1] == "/" ? server : server + "/");
        });
      } else {
        setState(() {
          _server.text = server[server.length - 1] == "/" ? check : check + "/";
          prefs.setString(SERVER_JITSI,
              server[server.length - 1] == "/" ? check : check + "/");
        });
      }
    } else if (focus == false && server == "") {
      setState(() {
        _server.text = defaultServer;
        prefs.setString(SERVER_JITSI, defaultServer);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setText();
    _focusNode.addListener(() {
      // print("Has focus: ${_focusNode.hasFocus}");
      CheckServer(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              //profile
              ListContainer(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/image/avatar.png'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<Person>(context).name != ""
                                  ? Provider.of<Person>(context).name
                                  : name.text == ""
                                      ? "test"
                                      : name.text,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            SizedBox(height: 3),
                            Text(
                              Provider.of<Person>(context).email != ""
                                  ? Provider.of<Person>(context).email
                                  : email.text == ""
                                      ? 'test@gmail.com'
                                      : email.text,
                              style: TextStyle(fontSize: 14, color: kTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 26,
                      icon: Icon(Icons.edit_outlined),
                      color: Colors.grey,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(name: name, email: email))),
                      tooltip: 'แก้ไข',
                    ),
                  ],
                ),
              )),
              SizedBox(height: size.height * 0.05),
              TextFieldBox(
                titleText: 'Default Server',
                hintText: 'Default Server https://meet.com',
                controller: _server,
                focusNode: _focusNode,
                onChanged: (value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(SERVER_JITSI, value);
                },
              ),
              SizedBox(height: size.height * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 15, right: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ปิดเสียงเมื่อเข้าห้องประชุม',
                                style: TextStyle(fontSize: 15),
                              ),
                              // CustomSwitch(
                              //     value: isSwitched,
                              //     onChanged: (value) async {
                              //       SharedPreferences prefs =
                              //           await SharedPreferences.getInstance();
                              //       setState(() {
                              //         isSwitched = value;
                              //         prefs.setBool(AUDIO_MUTE_JITSI, value);
                              //         print(isSwitched);
                              //       });
                              //     })
                              Switch(
                                value: isSwitched,
                                onChanged: (value) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool(AUDIO_MUTE_JITSI, value);
                                  setState(() {
                                    isSwitched = value;
                                  });
                                },
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.2, color: Colors.grey),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
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
                                  isSwitched2 = value;
                                  prefs.setBool(VIDEO_MUTE_JITSI, value);
                                  print(isSwitched2);
                                });
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('เวอร์ชั่น',
                        style: TextStyle(fontSize: 14, color: kTextColor)),
                    Text('1.0.3',
                        style: TextStyle(fontSize: 14, color: kTextColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

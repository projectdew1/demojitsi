import 'dart:io';

import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Methode/joint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  static final JointMethods jointMethods = JointMethods();

  final roomText = TextEditingController(text: "");
  final nameText = TextEditingController(text: "");
  final emailText = TextEditingController(text: "");

  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFF031811),
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: meetConfig(),
        ),
      ),
    );
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_call,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'สร้างห้องประชุม',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          )),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'ชื่อห้องประชุม',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          TextField(
            // focusNode: _focusNode,
            controller: roomText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          Text(
            'ชื่อผู้ใช้งาน',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          TextField(
            // focusNode: _focusNode,
            controller: nameText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          Text(
            'อีเมลล์',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          TextField(
            // focusNode: _focusNode,
            controller: emailText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              border: OutlineInputBorder(),
            ),
          ),
          // SizedBox(
          //   height: 14.0,
          // ),
          // CheckboxListTile(
          //   title: Text(
          //     "เปิดเสียงอย่างเดียวเมื่อเริ่มประชุม",
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   value: isAudioOnly,
          //   onChanged: _onAudioOnlyChanged,
          // ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text(
              "ปิดเสียงเมื่อเริ่มประชุม",
              style: TextStyle(color: Colors.white),
            ),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text(
              "ปิดวีดีโอเมื่อเริ่มประชุม",
              style: TextStyle(color: Colors.white),
            ),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
              },
              child: Text(
                "สร้างห้องประชุม",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue)),
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String serverUrl = await prefs.getString(SERVER_JITSI);
    String serverToken = serverUrl.substring(serverUrl.indexOf('://') + 3);
    String room = await jointMethods.roomConvert(roomText.text);

    if (room.trim() == "") {
      await EasyLoading.showError('กรุณากรอกชื่อห้อง');
      return;
    }

    if (nameText.text.trim() == "") {
      await EasyLoading.showError('กรุณากรอกชื่อผู้ใช้งาน');
      return;
    }

    final key = '83D8F671657020295CBBE977E90FB313';
    final claimSet = JwtClaim(
      audience: <String>['jitsi'],
      issuer: '123456',
      subject: serverToken,
      otherClaims: <String, dynamic>{"room": room},
    );

    // Generate a JWT from the claim set
    final token = issueJwtHS256(claimSet, key);

    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: room)
      ..serverURL = serverUrl
      // ..subject = subjectText.text
      ..userDisplayName = nameText.text
      ..userEmail = emailText.text
      // ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..token = token
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": room,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
            Navigator.pushNamed(context, '/background');
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
            Navigator.pop(context);
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}

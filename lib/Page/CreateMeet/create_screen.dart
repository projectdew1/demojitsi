import 'dart:io';

import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Methode/joint.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/create_body.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  static final JointMethods jointMethods = JointMethods();

  final room = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();

  // _CreateScreenState(this.room, this.name, this.email);

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

  _joinMeeting() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (room.text.trim() == "") {
      await EasyLoading.showError('กรุณากรอกชื่อห้อง');
      return;
    }

    if (name.text.trim() == "") {
      await EasyLoading.showError('กรุณากรอกชื่อผู้ใช้งาน');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String serverUrl = await prefs.getString(SERVER_JITSI);
    String serverToken = serverUrl.substring(serverUrl.indexOf('://') + 3);
    String roomtxt = await jointMethods.roomConvert(room.text);
    bool isAudioMuted = await prefs.getBool(AUDIO_MUTE_JITSI_C);
    bool isVideoMuted = await prefs.getBool(VIDEO_MUTE_JITSI_C);

    if (serverUrl.trim() == "") {
      serverUrl = "https://meet.frappet.com/";
      int http = room.text.indexOf("://");
      if (http >= 0) {
        int index = room.text.lastIndexOf("/");
        int checkName = index + 1;
        int link = http + 2;
        String str = room.text.substring(0, index);

        if (http == link) {
          await EasyLoading.showError('ชื่อห้องหรือ URL ไม่ถูกต้อง');
          return;
        }

        if (room.text.length == checkName) {
          await EasyLoading.showError('ลิ้งค์ URL กรุณากรอกชื่อห้อง');
          return;
        }

        if (str == "https:/" || str == "http:/") {
          await EasyLoading.showError('ชื่อห้องหรือ URL ไม่ถูกต้อง');
          return;
        }

        serverUrl = str;
      }
    }

    if (roomtxt.indexOf(".") >= 0) {
      await EasyLoading.showError('ชื่อห้องหรือ URL ไม่ถูกต้อง');
      return;
    }

    final key = '83D8F671657020295CBBE977E90FB313';
    final claimSet = JwtClaim(
      audience: <String>['jitsi'],
      issuer: '123456',
      subject: serverToken,
      otherClaims: <String, dynamic>{"room": roomtxt},
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
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomtxt)
      ..serverURL = serverUrl
      // ..subject = subjectText.text
      ..userDisplayName = name.text
      ..userEmail = email.text
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
        "userInfo": {"displayName": name.text}
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: buildAppBar(context),
        body: CreateMeetBody(room: room, name: name, email: email),
      ),
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
            'สร้างห้องประชุม',
            style: kHeadingTextStyle,
          ),
        ],
      ),
      leading: new TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ปิด')),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              _joinMeeting();
            },
            child: Text('สร้างห้อง'))
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

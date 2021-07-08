import 'dart:async';
import 'dart:io';

import 'package:demo_jitsi/Config/preference.dart';
import 'package:demo_jitsi/Config/provider.dart';
import 'package:demo_jitsi/Methode/joint.dart';
import 'package:demo_jitsi/Page/Main/background.dart';
import 'package:demo_jitsi/components/rounded_button.dart';
import 'package:demo_jitsi/components/rounded_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  static final JointMethods jointMethods = JointMethods();
  final roomText = TextEditingController();
  bool show = false;
  bool _initialUriIsHandled = false;
  String name = "";

  SharedPreferences preferences;
  StreamSubscription _sub;

  final _focusNode = FocusNode();

  Future<void> setText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setString(NAME_JITSI, "");
    prefs.setString(EMAIL_JITSI, "");
    prefs.setBool(AUDIO_MUTE_JITSI, false);
    prefs.setBool(VIDEO_MUTE_JITSI, false);
    prefs.setString(SERVER_JITSI, "");

    setState(() {
      name = prefs.getString(NAME_JITSI);
    });
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri uri) {
        if (!mounted) return;
        print('got uri: $uri');
        if (uri != null) {
          String package =
              uri.toString().replaceAll("com.frappet.meet", "https");
          int check = uri.toString().indexOf("com.frappet.meet");
          setState(() {
            roomText.text = check >= 0 ? package : uri.toString();
            // _err = null;
          });
          _joinMeeting();
        }
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        if (uri != null) {
          setState(() => roomText.text = uri.toString());
          _joinMeeting();
        }
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        // setState(() => _err = err);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setText();
    _handleIncomingLinks();
    _handleInitialUri();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
    _focusNode.addListener(() {
      setState(() {
        show = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    JitsiMeet.removeAllListeners();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Frappé T Meet",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    fontFamily: 'Kanit'),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "การประชุมทางวิดีโอที่ปลอดภัยและมีคุณภาพสูง",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.grey[700]),
              ),
              SizedBox(height: size.height * 0.06),
              SvgPicture.asset(
                "assets/icons/Group.svg",
                height: size.height * 0.30,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "ป้อนชื่อห้องประชุม หรือ  URL",
                controller: roomText,
                focusNode: _focusNode,
                onSubmitted: (value) {
                  _joinMeeting();
                },
              ),
              RoundedButton(
                text: "เชื่อมต่อ",
                press: () {
                  _joinMeeting();
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // Widget meetConfig() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         SizedBox(height: 10),
  //         Text(
  //           'ชื่อห้อง/URL',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 18,
  //           ),
  //         ),
  //         SizedBox(height: 10),
  //         TextField(
  //           focusNode: _focusNode,
  //           controller: roomText,
  //           style: TextStyle(color: Colors.white),
  //           decoration: InputDecoration(
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white, width: 2.0),
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white, width: 2.0),
  //             ),
  //             border: OutlineInputBorder(),
  //           ),
  //           onSubmitted: (value) {
  //             _joinMeeting();
  //           },
  //         ),
  //         AnimatedOpacity(
  //           opacity: show ? 1.0 : 0.0,
  //           duration: Duration(milliseconds: 300),
  //           child: Center(
  //             child: Card(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   const ListTile(
  //                     leading: Icon(Icons.connect_without_contact_outlined),
  //                     title: Text('เชื่อมต่อห้อง'),
  //                     subtitle: Text(
  //                         'กรุณากรอกชื่อห้องหรือ URL ห้องเพื่อเชื่อมต่อห้อง'),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       TextButton(
  //                         child: const Text('เชื่อมต่อห้อง'),
  //                         onPressed: () {
  //                           show ? _joinMeeting() : null;
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _joinMeeting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String room = await jointMethods.roomConvert(roomText.text);
    String serverUrl = await prefs.getString(SERVER_JITSI);
    bool isVideo = await prefs.getBool(VIDEO_MUTE_JITSI);
    bool isAudio = await prefs.getBool(AUDIO_MUTE_JITSI);

    // String serverUrl = "https://meet.frappet.com/";

    if (roomText.text.trim() == "") {
      await EasyLoading.showError('กรุณากรอกชื่อห้องหรือ URL');
      return;
    }

    if (serverUrl.trim() == "") {
      serverUrl = "https://meet.cmss-edubkk.com/";
      int http = roomText.text.indexOf("://");
      if (http >= 0) {
        int index = roomText.text.lastIndexOf("/");
        int checkName = index + 1;
        int link = http + 2;
        String str = roomText.text.substring(0, index);

        if (http == link) {
          await EasyLoading.showError('ชื่อห้องหรือ URL ไม่ถูกต้อง');
          return;
        }

        if (roomText.text.length == checkName) {
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

    if (room.indexOf(".") >= 0) {
      await EasyLoading.showError('ชื่อห้องหรือ URL ไม่ถูกต้อง');
      return;
    }

    String token = await jointMethods.jwt(roomText.text);

    if (token == "undefined") {
      token = "";
    }

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
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      }
    }

    // Define meetings options here
    var options = JitsiMeetingOptions(room: room)
      // ..serverURL = serverUrl
      ..serverURL = "https://meet.frappet.com/"
      ..subject = ""
      ..userDisplayName =
          prefs.getString(NAME_JITSI) == "" ? "me" : prefs.getString(NAME_JITSI)
      ..userEmail = prefs.getString(EMAIL_JITSI)
      // ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      // ..audioOnly = isAudioOnly
      ..audioMuted = isAudio
      ..videoMuted = isVideo
      ..token = token
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": room,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {
          "displayName": prefs.getString(NAME_JITSI) == ""
              ? "me"
              : prefs.getString(NAME_JITSI)
        }
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

            FocusManager.instance.primaryFocus?.unfocus();
            roomText.clear();
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

  Widget buildDraw(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Image.asset('assets/image/user.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Provider.of<Person>(context).name != ""
                          ? Provider.of<Person>(context).name
                          : "ME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('ตั้งค่า'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/setting');
              },
            ),
          ],
        ),
      );
}

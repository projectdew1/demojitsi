import 'package:demo_jitsi/Page/CreateMeet/create_screen.dart';
import 'package:demo_jitsi/Page/Setting/setting_screen.dart';
import 'package:demo_jitsi/Page/Main/meet_screen.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Config/provider.dart';
import 'Page/Create/createRoom.dart';
import 'Page/Jitsi/screen.dart';
import 'Page/Jitsi/index.dart';
import 'Page/Jitsi/setting.dart';

class Routes {
  Routes() {
    runApp(
      ChangeNotifierProvider(
        create: (_) => Person(name: "", email: ""),
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: new Meeting(),
          home: new MeetScreen(),
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Bai Jamjuree',
          ),
          // darkTheme: ThemeData(
          //   // primaryColor: Colors.blueGrey,
          //   // brightness: Brightness.light,
          //   fontFamily: 'Kanit',
          //   // scaffoldBackgroundColor: Colors.white,
          // ),
          builder: EasyLoading.init(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/setting':
                return new MyCustomRoute(
                  builder: (_) => new Setting(),
                  settings: settings,
                );
              case '/background':
                return new MyCustomRoute(
                  builder: (_) => new Screen(),
                  settings: settings,
                );
              case '/create':
                return new MyCustomRoute(
                  builder: (_) => new CreateRoom(),
                  settings: settings,
                );
              case '/createscreen':
                return new MyCustomRoute(
                  builder: (_) => new CreateScreen(),
                  settings: settings,
                );
              case '/settingscreen':
                return new MyCustomRoute(
                  builder: (_) => new SettingScreen(),
                  settings: settings,
                );
            }
          },
        ),
      ),
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.arguments) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}

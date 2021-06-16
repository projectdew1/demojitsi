import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  const Screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Image(
          image: AssetImage('assets/image/meeting.png'),
          height: 200,
        ),
      ),
    );
  }
}

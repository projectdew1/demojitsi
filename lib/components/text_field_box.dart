import 'package:demo_jitsi/components/list_container.dart';
import 'package:demo_jitsi/constants.dart';
import 'package:flutter/material.dart';

class TextFieldBox extends StatelessWidget {
  final String hintText, titleText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const TextFieldBox(
      {Key key, this.hintText, this.titleText, this.onChanged, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(titleText,
              style: TextStyle(
                  fontSize: 14,
                  // color: kTextColor,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: size.height * 0.015),
        ListContainer(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            cursorColor: kPrimaryColor,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ))
      ],
    ));
  }
}

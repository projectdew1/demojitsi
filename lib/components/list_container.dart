import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  final Widget child;
  const ListContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      /* padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), */
      decoration: new BoxDecoration(
        border: Border(
            top: BorderSide(
              color: Colors.grey[400],
              width: 0.2,
            ),
            bottom: BorderSide(
              color: Colors.grey[400],
              width: 0.2,
            )),
        color: Colors.white,
      ),
      child: child,
    );
  }
}

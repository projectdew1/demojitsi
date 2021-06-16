import 'package:flutter/foundation.dart';

class Person with ChangeNotifier {
  Person({this.name, this.email});
  String name;
  String email;

  void setName(name) {
    this.name = name;
    notifyListeners();
  }

  void setEmail(email) {
    this.email = email;
    notifyListeners();
  }
}

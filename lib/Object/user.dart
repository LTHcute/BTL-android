import 'package:flutter/foundation.dart';

class user extends ChangeNotifier {
  String sUsername;
  String sPassword;
  user({this.sUsername = "", this.sPassword = ""});

  String get username => sUsername;

  void setUsername(String username) {
    sUsername = username;
    notifyListeners();
  }
}

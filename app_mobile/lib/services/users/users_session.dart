import 'dart:convert';

import 'package:session_manager/session_manager.dart';

class UserSession {
  static String? user;

  void setUser() async{
     user = await SessionManager().getString("user");
  }

  static String? getUser() {
    return user;
  }

  Future saveUser(Object user) async{
    try {
      await SessionManager().setString("user",jsonEncode(user));
      setUser();
    } catch (e) {
      rethrow;
    }
  }

}
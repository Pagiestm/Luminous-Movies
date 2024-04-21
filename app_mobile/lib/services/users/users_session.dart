import 'dart:convert';
import '../../models/users.dart';

import 'package:session_manager/session_manager.dart';

class UserSession {
  static String? user;

  void setUser() async{
     user = await SessionManager().getString("user");
  }

  static User? getUser() {
    var fetchUser = user ?? "";
    if (fetchUser != "") {
      final userMap = jsonDecode(fetchUser) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
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
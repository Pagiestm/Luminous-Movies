import 'package:session_manager/session_manager.dart';

class UserSession {

  static Future<String> fetchUser() async{
     return await SessionManager().getString("user");
  }

  static String? getUser() {
    String? user;
    fetchUser().then((value) => user = value);
    return user;
  }

}
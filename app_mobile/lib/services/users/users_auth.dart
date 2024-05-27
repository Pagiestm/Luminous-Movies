import 'dart:convert';

import 'package:http/http.dart' as http;
import './users_session.dart';
import '../navigation.dart';

class UserAuth {
  Navigation navigation = Navigation.getInstance();
  static String role = "";

  Future fetchUser(String email, String password) async {
    var response = await http.post(
        Uri.parse('https://luminous-movies.onrender.com/users'),
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      authenticateUser(jsonBody);
      return jsonBody;
    } else {
      return null;
    }
  }

  void authenticateUser(user) async {
    await UserSession().saveUser(user).catchError((err) => throw err);

    role = user["role"];
    userRole();
    navigation.setIndex(0);
  }

  static Stream<String> userRole() async* {
    yield role;
  }

  Future updateUser(String id, String newEmail, String newPseudo) async {
    var response = await http.put(
      Uri.parse('https://luminous-movies.onrender.com/users/$id'),
      body: {
        'email': newEmail,
        'pseudo': newPseudo,
      },
    );

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      await UserSession().saveUser(jsonBody);
    } else {
      throw Exception('Échec de la mise à jour de l\'utilisateur.');
    }
  }
}

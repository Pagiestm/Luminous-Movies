import 'dart:convert';

import 'package:http/http.dart' as http;
import './users_session.dart';
import '../navigation.dart';

class UserAuth {
  Navigation navigation = Navigation.getInstance();

  Future fetchUser(String email, String password) async{
       var response = await http.post(Uri.parse('https://luminous-movies.onrender.com/users'), body: {
        'email': email,
        'password': password
       });

        if (response.statusCode == 200) {
          var jsonBody = jsonDecode(response.body);
          authenticateUser(jsonBody);
        } else {
          throw Exception('Échec de la récupération des données.');
        }
  }

  void authenticateUser(Object user) async{
    await UserSession()
      .saveUser(user)
      .catchError((err) => throw err);
    navigation.setIndex(0);
  }

}
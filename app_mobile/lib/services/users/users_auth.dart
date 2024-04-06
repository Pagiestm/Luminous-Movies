import 'dart:convert';
import 'package:http/http.dart' as http;
import './users_session.dart';
import '../../pages/Accueil.dart';

class UserAuth {

  static Future fetchUser(String email, String password) async{
      //https://luminous-movies.onrender.com/users
       var response = await http.post(Uri.parse('https://luminous-movies.onrender.com/users'), body: {
        'email': email,
        'password': password
       });

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          throw Exception('Échec de la récupération des données.');
        }
  }

  static void authenticateUser(Object user) async{
    await UserSession()
      .saveUser(user)
      .catchError((err) => throw err);
  }

}
import 'package:http/http.dart' as http;
import '../navigation.dart';

class UserRegister {
  Navigation navigation = Navigation.getInstance();

  Future addUser(String email, String password, String pseudo) async{
    var response = await http.post(Uri.parse('https://luminous-movies.onrender.com/users/add'), body: {
    'email': email,
    'password': password,
    'pseudo': pseudo
    });

    if (response.statusCode == 200) {
      return "User authentified";
    } else {
      throw Exception('Échec de la récupération des données.');
    }
  }
}
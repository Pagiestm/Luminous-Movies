import 'package:http/http.dart' as http;

class FavoritesService {
  Future add(String user, String movie) async{
    var response = await http.post(Uri.parse('https://luminous-movies.onrender.com/favorites'), body: {
    'movies': movie,
    'users': user,
    });

    if (response.statusCode == 200) {
      return "Favorite added";
    } else {
      throw Exception('Échec de la récupération des données.');
    }
  }
}
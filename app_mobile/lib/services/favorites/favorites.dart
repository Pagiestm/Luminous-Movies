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

    Future<bool> fetchFavoriteByMovieAndUser(String idMovie, String idUser) async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/favorites/$idUser/$idMovie'));
      var t = response.body;
      print("test: $t");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to fetch favorite.');
    }
  }
}
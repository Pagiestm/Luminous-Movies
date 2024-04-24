import 'package:http/http.dart' as http;

class FavoritesService {
  Future add(String user, String movie) async{
    var response = await http.post(Uri.parse('https://luminous-movies.onrender.com/favorites'),
      body: {
        'movies': movie,
        'users': user,
      });

    if (response.statusCode == 200) {
      return "Favorite added";
    } else {
      throw Exception('Échec de la récupération des données.');
    }
  }

  Future remove(String user, String movie) async{
    var response = await http.delete(Uri.parse('https://luminous-movies.onrender.com/favorites'),
      body: {
        'movies': movie,
        'users': user,
      });

    if (response.statusCode == 200) {
      return "Favorite deleted";
    } else {
      throw Exception('Échec de la récupération des données.');
    }
  }

  Future<bool> fetchFavoriteByMovieAndUser(String idMovie, String idUser) async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/favorites/$idUser/$idMovie'));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return true;
      }
      return false;
    } else {
      throw Exception('Failed to fetch favorite.');
    }
  }
}
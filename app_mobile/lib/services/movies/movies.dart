// movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  Future fetchMovies() async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/movies'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw Exception('Failed to fetch movie data.');
    }
  }
}
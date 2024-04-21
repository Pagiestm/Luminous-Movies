// movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/movies.dart';

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/movies'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movie data.');
    }
  }

  Future<List<Movie>> fetchMoviesByCategorie(String categorieId) async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/movies?categorie=$categorieId'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movies data.');
    }
  }
}
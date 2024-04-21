// movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/movies.dart';

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    var response = await http
        .get(Uri.parse('https://luminous-movies.onrender.com/movies'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movie data.');
    }
  }

  Future<List<Movie>> fetchMoviesByFavorites(String idUser) async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/movies/favorites/$idUser'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movies data.');
    }
  }

  Future<List<Movie>> fetchMoviesByCategorie(String categorie) async {
    var response = await http.get(Uri.parse(
        'https://luminous-movies.onrender.com/movies/categorie/$categorie'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movies data.');
    }
  }

  Future<List<Movie>> fetchMoviesByTitle(String title) async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/movies/title/$title'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}

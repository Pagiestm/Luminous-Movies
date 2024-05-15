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

  Future<List<Movie>> fetchMoviesByFavorites(String idUser) async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/movies/favorites/$idUser'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      print("jsonbody: ${jsonBody}");
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
    var response =
        await http.get(Uri.parse('https://luminous-movies.onrender.com/movies/title/$title'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<bool> deleteMovieById(String id) async {
    var response = await http.delete(Uri.parse(
      'https://luminous-movies.onrender.com/movies/$id'
    ));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to fetch movies data.');
    }
  }

    Future addMovie(String title, String synopsis, String image, List<String> staring, String releaseDate, String length, List<String> categories) async {
    var response = await http.post(
      Uri.parse('https://luminous-movies.onrender.com/movies/'),
      body: {
        'title': title,
        'synopsis': synopsis,
        'image': image,
        'staring': staring.join('|-|'),
        'release_date': releaseDate,
        'length': length,
        'categories': categories.join('|-|')
      }
    );
    if (response.statusCode == 200) {
      return "Movie added";
    } else {
      throw Exception('Failed to fetch movies data.');
    }
  }
}

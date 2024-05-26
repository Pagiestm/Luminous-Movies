import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:luminous_movies/models/ratings.dart';

import '../../models/movies.dart';

class RatingService {
  Future<List<Rating>> fetchRatingsByMovie(String movie) async {
    var response = await http.get(
        Uri.parse('https://luminous-movies.onrender.com/ratings/movie/$movie'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movie data.');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:luminous_movies/models/ratings.dart';

class RatingService {
  Future<List<Rating>> fetchRatingsByMovie(String idMovie) async {
    var response = await http.get(Uri.parse(
        'https://luminous-movies.onrender.com/ratings/movie/$idMovie'));

    if (response.statusCode == 200) {
      List jsonBody = jsonDecode(response.body);
      return jsonBody.map<Rating>((item) => Rating.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch ratings data.');
    }
  }

  Future<Rating> addRating(String user, String movie, String rating) async {
    var response = await http
        .post(Uri.parse('https://luminous-movies.onrender.com/ratings'), body: {
      'users': user,
      'movies': movie,
      'rating': rating,
    });

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return Rating.fromJson(jsonBody);
    } else {
      throw Exception('Failed to post ratings data.');
    }
  }

  Future<Rating> changeRating(
      String user, String movie, String ratingId, String rating) async {
    var response = await http.put(
        Uri.parse('https://luminous-movies.onrender.com/ratings/${ratingId}'),
        body: {
          'users': user,
          'movies': movie,
          'rating': rating,
        });

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return Rating.fromJson(jsonBody);
    } else {
      throw Exception('Failed to put ratings data.');
    }
  }
}

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
}

// movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/categories.dart';

class CategoriesService {
  Future<List<Categories>> fetchCategories() async {
    var response = await http.get(Uri.parse('https://luminous-movies.onrender.com/categories'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody.map<Categories>((item) => Categories.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch movie data.');
    }
  }
}

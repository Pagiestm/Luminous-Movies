// movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/categories.dart';

class CategoriesService {
  Future<List<Categories>> fetchCategories() async {
    var response = await http
        .get(Uri.parse('https://luminous-movies.onrender.com/categories'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody
          .map<Categories>((item) => Categories.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch movie data.');
    }
  }

  Future<Categories> createCategory(String name) async {
    var response = await http.post(
      Uri.parse('https://luminous-movies.onrender.com/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      return Categories.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category.');
    }
  }

  Future<Categories> addCategory(String name) async {
    var response = await http.post(
      Uri.parse('https://luminous-movies.onrender.com/categories/'),
      body: {
        'name': name,
      }
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return Categories.fromJson(jsonBody);
    } else {
      throw Exception('Failed to add category.');
    }
  }

  Future<Categories> updateCategory(String id, String name) async {
    var response = await http.put(
      Uri.parse('https://luminous-movies.onrender.com/categories/$id'),
      body: {
        'name': name,
      }
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return Categories.fromJson(jsonBody);
    } else {
      throw Exception('Failed to update category.');
    }
  }

  Future<bool> deleteCategory(String id) async {
    var response = await http
        .delete(Uri.parse('https://luminous-movies.onrender.com/categories/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete category.');
    }
  }
}

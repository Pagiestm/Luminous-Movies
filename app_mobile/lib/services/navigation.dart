import 'package:flutter/material.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/pages/MovieDetailsPage.dart';
import 'package:luminous_movies/services/favorites/favorites.dart';

class Navigation {
  static Navigation? _instance;

  Navigation._();

  static Navigation getInstance() {
    _instance ??= Navigation._();
    return _instance!;
  }

  static int index = 0;

  void setIndex(int value){
    index = value;
    selectedIndex();
  }

  Stream<int> selectedIndex() async* {
      yield index;
  }

    Future<Widget> toMovieDetailsPage(User? user, movie) async {
      if (user != null) {
        return MovieDetailsPage(movie: movie, isFavorite: await FavoritesService().fetchFavoriteByMovieAndUser(movie.id, user.id));
      }
      
      return MovieDetailsPage(movie: movie, isFavorite: false);
  }
}
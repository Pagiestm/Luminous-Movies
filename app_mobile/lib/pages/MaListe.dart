import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/services/movies/movies.dart';
import '../services/users/users_session.dart';
import 'Connexion.dart';

class MaListe extends StatefulWidget {
  const MaListe({super.key});

  @override
  _MaListe createState() => _MaListe();
}

class _MaListe extends State<MaListe> {
  List<Movie> movies = [];
  User? user = UserSession.getUser();

  @override
  void initState() {
    super.initState();
    fetchFavoritesMovies();
  }

  void fetchFavoritesMovies () async {
    if (user != null) {
      var fetchedMovies = await MovieService().fetchMoviesByFavorites(user!.id);
      setState(() {
        movies = fetchedMovies.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  if (user == null) {
    return Connexion();
  }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 64, 0, 16),
                child: Text(
                  'Les dernières sorties',
                  style: TextStyle(
                      fontFamily: 'Sora', fontSize: 24, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                childAspectRatio: 0.7,
                crossAxisCount: 3,
                children: List.generate(movies.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      movies[index].image,
                      fit: BoxFit.cover
                    ),
                  );
                }),
              )
            ]
          ),
      ),
    );
  }
}
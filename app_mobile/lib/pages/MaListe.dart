import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/models/users.dart';
import '../services/users/users_session.dart';
import 'Connexion.dart';

class MaListe extends StatefulWidget {
  const MaListe({super.key});

  @override
  _MaListe createState() => _MaListe();
}

class _MaListe extends State<MaListe> {

  @override
  Widget build(BuildContext context) {
  User? user = UserSession.getUser();
  List<Movie> movies = [];

  void fetchFavoritesMovies () async {
    
  }
  
  if (user == null) {
    return Connexion();
  } else {
    fetchFavoritesMovies();
  }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
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
                crossAxisCount: 3,
                children: List.generate(50, (index) {
                  return Center(
                    child: Text(
                      'Item $index',
                    ),
                  );
                }),
              )
            ]
          ),
        ),
      ),
    );
  }
}
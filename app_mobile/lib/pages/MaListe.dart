import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/pages/Decouvrir.dart';
import 'package:luminous_movies/pages/MovieDetailsPage.dart';
import 'package:luminous_movies/services/favorites/favorites.dart';
import 'package:luminous_movies/services/navigation.dart';
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
  bool toDecouvrir = false;
  Navigation navigation = Navigation.getInstance();

  @override
  void initState() {
    super.initState();
    fetchFavoritesMovies();
  }

  void fetchFavoritesMovies() async {
    if (user != null) {
      var fetchedMovies = await MovieService().fetchMoviesByFavorites(user!.id);
      setState(() {
        movies = fetchedMovies.toList();
      });
    }
  }

  Future<Widget> toMovieDetailsPage(int index) async {
    return user != null
        ? MovieDetailsPage(
            movie: movies[index],
            isFavorite: await FavoritesService()
                .fetchFavoriteByMovieAndUser(movies[index].id, user!.id))
        : MovieDetailsPage(movie: movies[index], isFavorite: false);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Connexion();
    } else if (toDecouvrir) {
      return Decouvrir();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ma liste',
            style: GoogleFonts.sora(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.zero,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              childAspectRatio: 0.7,
              crossAxisCount: 3,
              children: List.generate(movies.length, (index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                    future: toMovieDetailsPage(index),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Erreur: ${snapshot.error}');
                                      } else {
                                        return snapshot.data!;
                                      }
                                    },
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(movies[index].image,
                            fit: BoxFit.cover),
                      ),
                    ));
              }),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Vous arrivez à la fin de votre liste',
                      style: GoogleFonts.sora(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade900,
                      ),
                      onPressed: () {
                        setState(() => toDecouvrir = true);
                        navigation.setIndex(2);
                      },
                      child: Text(
                        'Voir plus de film',
                        style: GoogleFonts.sora(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 48)),
          ]),
        ),
      );
    }
  }
}

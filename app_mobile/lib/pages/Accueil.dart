import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/services/favorites/favorites.dart';
import 'package:luminous_movies/services/users/users_session.dart';
import '../services/movies/movies.dart';
import '../../models/movies.dart';
import 'MovieDetailsPage.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Movie> movies = [];
  List<Movie> favoriteMovies = [];
  User? user = UserSession.getUser();

  @override
  void initState() {
    super.initState();
    fetchMovies();
    if (user != null) {
      fetchFavoritesMovies();
    }
  }

  void fetchMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMovies();
    setState(() {
      movies = fetchedMovies.reversed.toList();
    });
  }

    void fetchFavoritesMovies() async {
      MovieService movieService = MovieService();
      var fetchedMovies = await movieService.fetchMoviesByFavorites(user!.id);
      setState(() {
        favoriteMovies = fetchedMovies.toList();
      });
  }

  Future<Widget> toMovieDetailsPage(int index, {String? typeOfMovie}) async {
    switch (typeOfMovie) {
      case "favorite":
        return user != null ? MovieDetailsPage(movie: favoriteMovies[index], isFavorite: await FavoritesService().fetchFavoriteByMovieAndUser(movies[index].id, user!.id)) : MovieDetailsPage(movie: favoriteMovies[index], isFavorite: false);
      default:
        return user != null ? MovieDetailsPage(movie: movies[index], isFavorite: await FavoritesService().fetchFavoriteByMovieAndUser(movies[index].id, user!.id)) : MovieDetailsPage(movie: movies[index], isFavorite: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 0, 16),
            child: Text(
              'Les dernières sorties',
              style: TextStyle(
                  fontFamily: 'Sora', fontSize: 24, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 400, // Définit la hauteur du slider d'images
            child: PageView.builder(
              controller: PageController(
                  viewportFraction:
                      0.8), // Affiche une petite partie des images suivantes
              itemCount: movies.length > 5 ? 5 : movies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: toMovieDetailsPage(index), 
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                            } else {
                              return snapshot.data!;
                            }
                          }
                        )
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    // Ajoute des marges à gauche et à droite de chaque image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Arrondit les bords de l'image
                      child: CachedNetworkImage(
                        imageUrl: movies[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          user != null ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Text(
              'Votre liste',
              style: TextStyle(
                  fontFamily: 'Sora', fontSize: 20, color: Colors.white),
            ),
          ) : SizedBox(height: 0),
          user != null ? Container(
            height: 175, // Définit la hauteur du slider d'images
            child: PageView.builder(
              controller: PageController(
                  viewportFraction:
                      0.8), // Affiche une petite partie des images suivantes
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: toMovieDetailsPage(index, typeOfMovie: "favorite"), 
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                            } else {
                              return snapshot.data!;
                            }
                          }
                        )
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    // Ajoute des marges à gauche et à droite de chaque image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Arrondit les bords de l'image
                      child: CachedNetworkImage(
                        imageUrl: favoriteMovies[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ) : SizedBox(height: 0),
        ],
      ),
    );
  }
}

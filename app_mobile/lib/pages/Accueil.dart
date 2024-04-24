import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:luminous_movies/components/favorites_movies.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/services/navigation.dart';
import 'package:luminous_movies/services/users/users_session.dart';
import '../services/movies/movies.dart';
import '../../models/movies.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Movie> movies = [];
  User? user = UserSession.getUser();
  FavoritesMovies? widgetFavoritesMovies;

  @override
  void initState() {
    super.initState();
    fetchMovies();
    if (user != null) {
      widgetFavoritesMovies = FavoritesMovies();
    }
  }

  void fetchMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMovies();
    setState(() {
      movies = fetchedMovies.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
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
                  onTap: () async {
                    final bool? shouldRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: Navigation.getInstance().toMovieDetailsPage(user, movies[index]), 
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                            } else {
                              return snapshot.data!;
                            }
                          }
                        )
                      ),
                    );
                    if (shouldRefresh == true && user != null) {
                      setState(() {
                        widgetFavoritesMovies = FavoritesMovies(key: UniqueKey(),);
                      });
                    }
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
          widgetFavoritesMovies != null ? widgetFavoritesMovies! : SizedBox(height: 0),
        ],
      ),
    );
  }
}

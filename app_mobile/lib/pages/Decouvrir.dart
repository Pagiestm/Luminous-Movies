import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/components/favorites_movies.dart';
import 'package:luminous_movies/models/categories.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/services/categories/categories.dart';
import 'package:luminous_movies/services/movies/movies.dart';
import 'package:luminous_movies/services/navigation.dart';
import 'package:luminous_movies/services/users/users_session.dart';

class Decouvrir extends StatefulWidget {
  const Decouvrir({super.key});

  @override
  _DecouvrirState createState() => _DecouvrirState();
}

class _DecouvrirState extends State<Decouvrir> {
  List<Movie> movies = [];
  List<Categories> categories = [];
  User? user = UserSession.getUser();
  FavoritesMovies? widgetFavoritesMovies;

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchCategories();
  }

  void fetchMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMovies();
    setState(() {
      movies = fetchedMovies.reversed.toList();
    });

    print(movies[0].categories);
  }

  void fetchCategories() async {
    CategoriesService categoriesService = CategoriesService();
    var fetchedCategories = await categoriesService.fetchCategories();
    setState(() {
      categories = fetchedCategories.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Découvrir',
          style: GoogleFonts.sora(
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Column(
        children: [
          for (var category in categories)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category.name,
                    style: GoogleFonts.sora(
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  height: 400, // Définit la hauteur du slider d'images
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
                    // Affiche une petite partie des images suivantes
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final bool? shouldRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FutureBuilder(
                                    future: Navigation.getInstance()
                                        .toMovieDetailsPage(
                                            user, movies[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Erreur: ${snapshot.error}');
                                      } else {
                                        return snapshot.data!;
                                      }
                                    })),
                          );
                          if (shouldRefresh == true && user != null) {
                            setState(() {
                              widgetFavoritesMovies = FavoritesMovies(
                                key: UniqueKey(),
                              );
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
              ],
            )
        ],
      ),
    );
  }
}

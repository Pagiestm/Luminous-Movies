import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/components/favorites_movies.dart';
import 'package:luminous_movies/models/categories.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/pages/Decouvrir.dart';
import 'package:luminous_movies/services/categories/categories.dart';
import 'package:luminous_movies/services/movies/movies.dart';
import 'package:luminous_movies/services/navigation.dart';
import 'package:luminous_movies/services/users/users_session.dart';

import '../../models/movies.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Movie> movies = [];
  List<Categories> categories = [];
  User? user = UserSession.getUser();
  FavoritesMovies? widgetFavoritesMovies;
  bool toDecouvrir = false;
  bool isLoadingMovies = true; // Ajout de cette ligne
  bool isLoadingCategories = true; // Ajout de cette ligne
  Navigation navigation = Navigation.getInstance();

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchCategories();
    if (user != null) {
      widgetFavoritesMovies = FavoritesMovies();
    }
  }

  void fetchMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMovies();
    setState(() {
      movies = fetchedMovies.reversed.toList();
      isLoadingMovies = false; // Mise à jour de l'état de chargement
    });
  }

  void fetchCategories() async {
    CategoriesService categoriesService = CategoriesService();
    var fetchedCategories = await categoriesService.fetchCategories();
    fetchedCategories.shuffle();
    setState(() {
      categories = fetchedCategories.take(3).toList();
      isLoadingCategories = false; // Mise à jour de l'état de chargement
    });
  }

  @override
  Widget build(BuildContext context) {
    if (toDecouvrir) {
      return Decouvrir();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Accueil',
            style: GoogleFonts.sora(
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: false,
        ),
        body: isLoadingMovies || isLoadingCategories // Ajout de cette condition
          ? Center(child: CircularProgressIndicator()) // Affichage de l'indicateur de chargement
          : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Les dernières sorties",
                      style: GoogleFonts.sora(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 400,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
                    itemCount: movies.length > 5 ? 5 : movies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final bool? shouldRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                future: Navigation.getInstance()
                                    .toMovieDetailsPage(user, movies[index]),
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
                                    return Text('Erreur: ${snapshot.error}',
                                        style: GoogleFonts.sora(
                                          fontSize: 24,
                                        ));
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
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
                widgetFavoritesMovies != null
                  ? widgetFavoritesMovies!
                  : SizedBox(height: 0),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var moviesByCategory = [];

                    for (var movie in movies) {
                      for (var cat in movie.categories) {
                        if (cat == categories[index].name) {
                          moviesByCategory.add(movie);
                        }
                      }
                    }

                    if (moviesByCategory.isEmpty) {
                      return SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${categories[index].name.substring(0, 1).toUpperCase()}${categories[index].name.substring(1).toLowerCase()}",
                              style: GoogleFonts.sora(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: PageController(viewportFraction: 0.4),
                            itemCount: moviesByCategory.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  final bool? shouldRefresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FutureBuilder(
                                        future: Navigation.getInstance()
                                            .toMovieDetailsPage(user,
                                                moviesByCategory[index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: SizedBox(
                                                height: 40,
                                                width: 40,
                                                child:
                                                    CircularProgressIndicator(),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: moviesByCategory[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24)),
                      ],
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    // Ajoutez ce widget
                    child: Column(
                      children: [
                        Text(
                          'Vous arrivez à la fin du fil',
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
              ],
            ),
          ));
    }
  }
}

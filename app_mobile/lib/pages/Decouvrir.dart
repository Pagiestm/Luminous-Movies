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
  int displayedCategoriesCount = 5;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchCategories();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreCategories();
    }
  }

  void _loadMoreCategories() {
    setState(() {
      int newCount = 0;
      for (int i = displayedCategoriesCount;
          i < categories.length && newCount < 2;
          i++) {
        var moviesByCategory = [];
        for (var movie in movies) {
          for (var cat in movie.categories) {
            if (cat == categories[i].name) {
              moviesByCategory.add(movie);
            }
          }
        }
        if (moviesByCategory.isNotEmpty) {
          newCount++;
        }
      }
      displayedCategoriesCount += newCount;
    });
  }

  void fetchMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMovies();
    setState(() {
      movies = fetchedMovies.reversed.toList();
    });
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: displayedCategoriesCount,
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${categories[index].name.substring(0, 1).toUpperCase()}${categories[index].name.substring(1).toLowerCase()}",
                          style: GoogleFonts.sora(
                            fontSize: 24,
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
                                final bool? shouldRefresh =
                                    await Navigator.push(
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
                      Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 24)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

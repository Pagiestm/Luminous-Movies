import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luminous_movies/models/movies.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/services/movies/movies.dart';
import 'package:luminous_movies/services/navigation.dart';
import 'package:luminous_movies/services/users/users_session.dart';

class FavoritesMovies extends StatefulWidget {
  final String? category;
  const FavoritesMovies({super.key, this.category});

  @override
  _FavoritesMovies createState() => _FavoritesMovies();
}

class _FavoritesMovies extends State<FavoritesMovies> {
  User? user = UserSession.getUser();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      
    } else if (user != null) {
      fetchFavoritesMovies();
    } 
  }
  
  List<Movie> movies = [];

  void fetchFavoritesMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMoviesByFavorites(user!.id);
    setState(() {
      movies = fetchedMovies.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Text(
            'Votre liste',
            style: TextStyle(
                fontFamily: 'Sora', fontSize: 20, color: Colors.white
            ),
          ),
        ),
        Container(
          child: movies.length > 2 ? CarouselSlider.builder(
          itemCount: movies.length,
          options: CarouselOptions(
            height: 175.0, 
            viewportFraction: 0.4,
            enableInfiniteScroll: true
          ),
          itemBuilder: (BuildContext context, int index, int pageViewIndex) => 
          GestureDetector(
            onTap: () async {
              final bool? shouldRefresh = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureBuilder(
                    future: Navigation.getInstance().toMovieDetailsPage(user!, movies[index]), 
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
              if (shouldRefresh == true) {
                setState(() {
                  fetchFavoritesMovies();
                });
              }
            },
              child: Container(
                width: 125,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Arrondit les bords de l'image
                  child: CachedNetworkImage(
                    imageUrl: movies[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ) : SizedBox(
            height: 175,
            child: Row(
              children: [
              for (var i = 0; i < movies.length; i++)
              GestureDetector(
                onTap: () async {
                  final bool? shouldRefresh = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder(
                        future: Navigation.getInstance().toMovieDetailsPage(user!, movies[i]), 
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
                  if (shouldRefresh == true) {
                    setState(() {
                      fetchFavoritesMovies();
                    });
                  }
                },
                  child: Container(
                    width: 125,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Arrondit les bords de l'image
                      child: CachedNetworkImage(
                        imageUrl: movies[i].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            )
          ),
        )
      ],
    );
  }
}

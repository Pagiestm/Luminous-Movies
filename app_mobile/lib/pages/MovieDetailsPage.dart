import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/components/favorites_movies.dart';
import 'package:luminous_movies/models/ratings.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:luminous_movies/services/navigation.dart';
import 'package:luminous_movies/services/ratings/ratings.dart';

import '../models/movies.dart';
import '../services/favorites/favorites.dart';
import '../services/movies/movies.dart';
import '../services/users/users_session.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  bool isFavorite;
  FavoritesMovies widgetFavoritesMovies = FavoritesMovies(key: UniqueKey());

  MovieDetailsPage({required this.movie, required this.isFavorite});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  List<String> sameCategoryMovies = [];
  User? user = UserSession.getUser();
  late FavoritesMovies widgetFavoritesMovies;
  List<Rating> listRatings = [];

  @override
  void initState() {
    super.initState();
    fetchRatingByMovie(widget.movie.id);
    widgetFavoritesMovies = FavoritesMovies(key: UniqueKey());
    fetchRatingByMovie(widget.movie.id).then((ratings) {
      setState(() {
        listRatings = ratings;
      });
    });
  }

  Future<List<Movie>> fetchMoviesForCategories(List<String> categories) async {
    List<Movie> movies = [];
    for (String category in categories) {
      List<Movie> categoryMovies =
          await MovieService().fetchMoviesByCategorie(category);
      movies.addAll(categoryMovies);
    }
    return movies;
  }

  Future<List<Rating>> fetchRatingByMovie(String idMovie) async {
    List<Rating> ratings = await RatingService().fetchRatingsByMovie(idMovie);
    return ratings;
  }

  void addToFavorite() {
    FavoritesService().add(user!.id, widget.movie.id).then((value) => {
          setState(() {
            widget.isFavorite = !widget.isFavorite;
          })
        });
  }

  void removeFromFavorite() {
    FavoritesService().remove(user!.id, widget.movie.id).then((value) => {
          setState(() {
            widget.isFavorite = !widget.isFavorite;
          })
        });
  }

  void addRating(rating) {
    print(rating);
  }

  @override
  Widget build(BuildContext context) {
    int Rating;
    bool matchUserFound = false;
    int OPACITY_RATING = 100;

    for (var value in listRatings) {
      if (value.users == user!.id) {
        matchUserFound = true;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Material(
            color: Colors.transparent,
            child: SvgPicture.asset(
              "assets/icons/arrow-left.svg",
              width: 32,
              height: 32,
              color: Colors.grey.shade700,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        actions: <Widget>[
          user != null
              ? IconButton(
                  icon: Material(
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      widget.isFavorite
                          ? "assets/icons/heart-fill.svg"
                          : "assets/icons/heart.svg",
                      width: 24,
                      height: 24,
                      color: widget.isFavorite ? Colors.red : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (!widget.isFavorite) {
                      addToFavorite();
                    } else {
                      removeFromFavorite();
                    }
                  },
                )
              : SizedBox(height: 0),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 500,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.movie.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.movie.title,
                  style: GoogleFonts.sora(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.movie.synopsis,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Acteurs",
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.movie.staring.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Icon(Icons.circle, size: 6, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.movie.staring[index],
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 6),
                Text(
                  "Durée",
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.movie.length,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Catégorie",
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.movie.categories.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Icon(Icons.circle, size: 6, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.movie.categories[index],
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Date de sortie",
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.movie.releaseDate,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Note global",
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                FutureBuilder(
                    future: fetchRatingByMovie(widget.movie.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Text(
                            "Pas encore noté",
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          double totalRating = 0;
                          snapshot.data?.forEach((element) {
                            totalRating += element.rating;
                          });
                          totalRating = totalRating / snapshot.data!.length;

                          return Text(
                            "${totalRating}/5",
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          );
                        }
                      }
                    }),
                SizedBox(height: 16),
                user != null
                    ? Column(
                        children: [
                          Text(
                            "Qu'avez-vous pensez de ce film ?",
                            style: GoogleFonts.sora(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          for (var value in listRatings)
                            if (value.users == user!.id) ...[
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                  ),
                                  Text(
                                    "Vous avez déjà mis un avis pour ce film. Vous pouvez le modifier à tout moment.",
                                    style: GoogleFonts.sora(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // Centrer les éléments horizontalement
                                      children: [
                                        IconButton(
                                          onPressed: () => addRating(1),
                                          icon: Material(
                                            color: Colors.transparent,
                                            child: SvgPicture.asset(
                                              "assets/icons/rating-1.svg",
                                              color: value.rating == 1
                                                  ? Color.fromARGB(
                                                      255, 255, 10, 10)
                                                  : Color.fromARGB(
                                                      OPACITY_RATING,
                                                      255,
                                                      10,
                                                      10),
                                              width: 48,
                                              height: 48,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => addRating(2),
                                          icon: Material(
                                            color: Colors.transparent,
                                            child: SvgPicture.asset(
                                              "assets/icons/rating-2.svg",
                                              color: value.rating == 2
                                                  ? Color.fromARGB(
                                                      255, 242, 146, 2)
                                                  : Color.fromARGB(
                                                      OPACITY_RATING,
                                                      242,
                                                      146,
                                                      2),
                                              width: 48,
                                              height: 48,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => addRating(3),
                                          icon: Material(
                                            color: Colors.transparent,
                                            child: SvgPicture.asset(
                                              "assets/icons/rating-3.svg",
                                              color: value.rating == 3
                                                  ? Color.fromARGB(
                                                      255, 235, 255, 10)
                                                  : Color.fromARGB(
                                                      OPACITY_RATING,
                                                      235,
                                                      255,
                                                      10),
                                              width: 48,
                                              height: 48,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => addRating(4),
                                          icon: Material(
                                            color: Colors.transparent,
                                            child: SvgPicture.asset(
                                              "assets/icons/rating-4.svg",
                                              color: value.rating == 4
                                                  ? Color.fromARGB(
                                                      255, 92, 230, 44)
                                                  : Color.fromARGB(
                                                      OPACITY_RATING,
                                                      92,
                                                      230,
                                                      44),
                                              width: 48,
                                              height: 48,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => addRating(5),
                                          icon: Material(
                                            color: Colors.transparent,
                                            child: SvgPicture.asset(
                                              "assets/icons/rating-5.svg",
                                              color: value.rating == 5
                                                  ? Color.fromARGB(
                                                      255, 32, 156, 5)
                                                  : Color.fromARGB(
                                                      OPACITY_RATING,
                                                      32,
                                                      156,
                                                      5),
                                              width: 48,
                                              height: 48,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ] else if (!matchUserFound) ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // Centrer les éléments horizontalement
                                  children: [
                                    IconButton(
                                      onPressed: () => addRating(1),
                                      icon: Material(
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          "assets/icons/rating-1.svg",
                                          color:
                                              Color.fromARGB(255, 255, 10, 10),
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => addRating(2),
                                      icon: Material(
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          "assets/icons/rating-2.svg",
                                          color:
                                              Color.fromARGB(255, 242, 146, 2),
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => addRating(3),
                                      icon: Material(
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          "assets/icons/rating-3.svg",
                                          color:
                                              Color.fromARGB(255, 235, 255, 10),
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => addRating(4),
                                      icon: Material(
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          "assets/icons/rating-4.svg",
                                          color:
                                              Color.fromARGB(255, 92, 230, 44),
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => addRating(5),
                                      icon: Material(
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          "assets/icons/rating-5.svg",
                                          color:
                                              Color.fromARGB(255, 32, 156, 5),
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                        ],
                      )
                    : SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                ),
                SizedBox(height: 16),
                Text(
                  "D'autres films du même genre...",
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                FutureBuilder<List<Movie>>(
                  future: fetchMoviesForCategories(widget.movie.categories),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Movie> movies = snapshot.data as List<Movie>;
                      List<Movie> filteredMovies = movies
                          .where((movie) => movie.title != widget.movie.title)
                          .toList();
                      if (filteredMovies.isEmpty) {
                        return Text(
                          "Il n'y a pas d'autres films du même genre...",
                          style: GoogleFonts.sora(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredMovies.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  final bool? shouldRefresh =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FutureBuilder(
                                          future: Navigation.getInstance()
                                              .toMovieDetailsPage(
                                                  user, filteredMovies[index]),
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
                                                'Erreur: ${snapshot.error}',
                                                style: GoogleFonts.sora(
                                                  fontSize: 24,
                                                ),
                                              );
                                            } else {
                                              return snapshot.data!;
                                            }
                                          }),
                                    ),
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
                                      imageUrl: filteredMovies[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}

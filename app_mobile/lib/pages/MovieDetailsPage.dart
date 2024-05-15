import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/models/users.dart';

import '../models/movies.dart';
import '../services/favorites/favorites.dart';
import '../services/movies/movies.dart';
import '../services/users/users_session.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  bool isFavorite;

  MovieDetailsPage({required this.movie, required this.isFavorite});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  List<String> sameCategoryMovies = [];
  User? user = UserSession.getUser();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: Text(
          "Retour",
          style: GoogleFonts.sora(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          user != null
              ? IconButton(
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                        widget.isFavorite ? Colors.red.shade900 : Colors.white,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.movie.synopsis,
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Acteurs",
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                              fontSize: 12,
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
                  "Durée",
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.movie.length,
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Catégorie",
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                              fontSize: 12,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.movie.releaseDate,
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "D'autres films du même genre...",
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                      return Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) {
                            if (!sameCategoryMovies
                                .contains(filteredMovies[index].title)) {
                              sameCategoryMovies
                                  .add(filteredMovies[index].title);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                      filteredMovies[index].image),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}

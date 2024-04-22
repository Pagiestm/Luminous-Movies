import 'package:flutter/material.dart';
import 'package:luminous_movies/models/users.dart';
import '../models/movies.dart';
import '../services/movies/movies.dart';
import '../services/favorites/favorites.dart';
import '../services/users/users_session.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  MovieDetailsPage({required this.movie});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  List<String> sameCategoryMovies = [];
  User? user = UserSession.getUser();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isAlreadyFavorite();
  }

  Future<List<Movie>> fetchMoviesForCategories(List<String> categories) async {
    List<Movie> movies = [];
    for (String category in categories) {
      List<Movie> categoryMovies = await MovieService().fetchMoviesByCategorie(category);
      movies.addAll(categoryMovies);
    }
    return movies;
  }

  void isAlreadyFavorite () async {
    if (user != null) {
      if (await FavoritesService().fetchFavoriteByMovieAndUser(widget.movie.id, user!.id)) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Retour",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          user != null ? IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red.shade900 : Colors.white,
            ),
            onPressed: () {
              FavoritesService().add(user!.id, widget.movie.id).then((value) => {
                setState(() {
                  isFavorite = !isFavorite;
                })
              });
            },
          ) : SizedBox(height: 0),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.movie.synopsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Acteurs",
                style: TextStyle(
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
                          style: TextStyle(
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.movie.length,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Catégorie",
                style: TextStyle(
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
                          style: TextStyle(
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.movie.releaseDate,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "D'autres films du même genre...",
                style: TextStyle(
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
                    List<Movie> filteredMovies = movies.where((movie) => movie.title != widget.movie.title).toList();
                    return Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          if (!sameCategoryMovies.contains(filteredMovies[index].image)) {
                            sameCategoryMovies.add(filteredMovies[index].image);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(filteredMovies[index].image),
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
        )
      ),
    );
  }
}

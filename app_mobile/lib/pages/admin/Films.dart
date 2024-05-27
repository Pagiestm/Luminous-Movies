import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/models/movies.dart';
import '../../services/movies/movies.dart';
import '../../components/AddUpdateMovieModal.dart';
import 'package:elegant_notification/elegant_notification.dart';

class Films extends StatefulWidget {
  const Films({super.key});

  @override
  FilmsState createState() {
    return FilmsState();
  }
}

class FilmsState extends State<Films> {
  bool isLoading = false;
  List<Movie> movies = [];

  void fetchMovies() async {
    var fetchMovies = await MovieService().fetchMovies();
    setState(() {
      movies = fetchMovies;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                  title: Text('Films', style: GoogleFonts.getFont('Sora')),
                  backgroundColor: Colors.black,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_sharp),
                      onPressed: () async {
                        Movie? movieAdded = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddUpdateMovieModal();
                          },
                        );
                        if (movieAdded != null) {
                          setState(() {
                            movies.add(movieAdded);
                          });
                        }
                      },
                    ),
                  ]),
            ],
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
          Expanded(
            child: Container(
              child: movies.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      shrinkWrap: true,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        var moviesReversed = movies.reversed.toList();
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.movie),
                                title: Text(moviesReversed[index].title),
                                subtitle: Text(
                                    "${moviesReversed[index].releaseDate} - ${moviesReversed[index].length}"),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  moviesReversed[index].synopsis,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: GoogleFonts.getFont('Sora'),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Modifier'),
                                    onPressed: () async {
                                      Movie? movieUpdated = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AddUpdateMovieModal(
                                            updatingMovie:
                                                moviesReversed[index],
                                          );
                                        },
                                      );
                                      if (movieUpdated != null) {
                                        setState(() {
                                          movies[movies.indexWhere((element) =>
                                              element.id ==
                                              movieUpdated.id)] = movieUpdated;
                                        });
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Supprimer'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmation'),
                                            content: Text(
                                                'Êtes-vous sûr de vouloir supprimer le film ${moviesReversed[index].title} ?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Annuler'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Supprimer'),
                                                onPressed: () {
                                                  MovieService()
                                                      .deleteMovieById(
                                                          moviesReversed[index]
                                                              .id)
                                                      .then((_) {
                                                    setState(() {
                                                      movies.removeWhere(
                                                          (element) =>
                                                              element.id ==
                                                              moviesReversed[
                                                                      index]
                                                                  .id);
                                                    });
                                                    Navigator.of(context).pop();

                                                    // Afficher une notification élégante
                                                    ElegantNotification.success(
                                                      title: Text(
                                                          "Film supprimé",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      description: Text(
                                                          '${moviesReversed[index].title} a été supprimé avec succès.',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ).show(context);
                                                  }).catchError((e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Une erreur est survenue lors de la suppression du film: $e'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

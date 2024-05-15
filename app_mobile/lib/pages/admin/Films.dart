import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/models/movies.dart';
import '../../services/movies/movies.dart';
import './AddMovieModal.dart';

class Films extends StatefulWidget {
  const Films({super.key});

  @override
  FilmsState createState() {
    return FilmsState();
  }
}

class FilmsState extends State<Films> {
  bool isLoading = false;

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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddMovieModal();
                        },
                      );
                    },
                  ),
                ]
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: MovieService().fetchMovies(), 
              builder: (context, snapshot){
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
                  List<Movie> movies = snapshot.data as List<Movie>;
                  List<Movie> moviesReversed = movies.reversed.toList();
                  return Container(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      shrinkWrap: true,
                      itemCount: movies.length,
                      itemBuilder: (context, index){
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
                                  "${moviesReversed[index].releaseDate} - ${moviesReversed[index].length}"
                                ),
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
                                    onPressed: () { /* ... */ },
                                  ),
                                  TextButton(
                                    child: const Text('Supprimer'),
                                    onPressed: () { 
                                      MovieService().deleteMovieById(moviesReversed[index].id).then((value) => {
                                        setState(() {
                                          moviesReversed.removeWhere((element) => element.id == moviesReversed[index].id);
                                        })
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}

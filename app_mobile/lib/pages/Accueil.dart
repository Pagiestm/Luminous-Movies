import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../services/movies/movies.dart';
import '../../models/movies.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    MovieService movieService = MovieService();
    var fetchedMovies = await movieService.fetchMovies();
    setState(() {
      movies = fetchedMovies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 0, 16),
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
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
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
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Text(
              'Votre liste',
              style: TextStyle(
                  fontFamily: 'Sora', fontSize: 20, color: Colors.white),
            ),
          ),
          Container(
            height: 175, // Définit la hauteur du slider d'images
            child: PageView.builder(
              controller: PageController(
                  viewportFraction:
                      0.8), // Affiche une petite partie des images suivantes
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

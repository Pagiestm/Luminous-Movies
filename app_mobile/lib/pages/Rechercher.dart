import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/movies.dart';
import '../services/movies/movies.dart';
import 'MovieDetailsPage.dart';

void main() => runApp(const Rechercher());

class Rechercher extends StatefulWidget {
  const Rechercher({Key? key}) : super(key: key);

  @override
  State<Rechercher> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<Rechercher> {
  final TextEditingController _controller = TextEditingController();
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  bool _searched = false;

  void _timer(e) {
    Timer(const Duration(seconds: 1), _search).isActive
        ? Timer(const Duration(seconds: 1), _search).cancel()
        : null;
  }

  Future<void> _search() async {
    String title = _controller.text;
    if (title.isEmpty) {
      setState(() {
        _movies = [];
        _searched = true;
      });
    } else {
      List<Movie> movies = await _movieService.fetchMoviesByTitle(title);
      setState(() {
        _movies = movies;
        _searched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recherche',
          style: GoogleFonts.sora(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (e) => _timer(e),
              controller: _controller,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Rechercher un film',
                suffixIcon: IconButton(
                  icon: Material(
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      "assets/icons/magnifying-glass.svg",
                      width: 24,
                      height: 24,
                      color: Color.fromARGB(255, 203, 202, 202),
                    ),
                  ),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 85, 84, 84)),
                ),
                filled: true,
                fillColor: Colors.grey.shade700,
              ),
              style: GoogleFonts.sora(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: !_searched
                    ? Container(key: ValueKey(0))
                    : _movies.isEmpty
                        ? Center(
                            key: ValueKey(1),
                            child: Text(
                              'Aucun résultat',
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GridView.builder(
                            key: ValueKey(2),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: _movies.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsPage(
                                        movie: _movies[index],
                                        isFavorite: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      _movies[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

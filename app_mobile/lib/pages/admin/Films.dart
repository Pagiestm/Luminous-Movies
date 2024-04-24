import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Films extends StatefulWidget {
  const Films({super.key});

  @override
  FilmsState createState() {
    return FilmsState();
  }
}

class FilmsState extends State<Films> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Text('Ajouter un film', style: GoogleFonts.getFont('Sora')),
            backgroundColor: Colors.black,
          ),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
          TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Nom du film",
              suffixIcon: Material(
                color: Colors.transparent,
                child: SvgPicture.asset(
                  "assets/icons/movie.svg",
                  width: 24,
                  height: 24,
                  color: Color.fromARGB(255, 203, 202, 202),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Color.fromARGB(255, 85, 84, 84)),
              ),
              filled: true,
              fillColor: Colors.grey.shade700,
            ),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

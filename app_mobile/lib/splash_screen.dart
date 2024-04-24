import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'navbar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => NavBar(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
              top: -125,
              left: -60,
              child: Transform.rotate(
                angle: 0.6,
                child: Material(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    "assets/icons/rouleau-movie-big.svg",
                    width: 512,
                    height: 512,
                    color: Colors.red.shade900,
                  ),
                ),
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        "assets/icons/movie.svg",
                        width: 48,
                        height: 48,
                        color: Colors.red.shade900,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Luminous Movies',
                        style: GoogleFonts.sora(
                          fontSize: 32,
                        )),
                  ],
                ),
                SizedBox(height: 30),
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              ],
            ),
          ),
          Positioned(
            bottom: -60,
            right: -5,
            child: Material(
              color: Colors.transparent,
              child: SvgPicture.asset(
                "assets/icons/rouleau-movie.svg",
                width: 156,
                height: 156,
                color: Colors.red.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luminous_movies/models/users.dart';

import '../services/users/users_session.dart';
import 'Connexion.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  MyProfil createState() => MyProfil();
}

class MyProfil extends State<Profil> {
  User? user = UserSession.getUser();

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Connexion();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mon profil',
          style:
              TextStyle(fontFamily: 'Sora', fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Column(children: [
        Center(
          child: Material(
              color: Colors.transparent,
              child: SvgPicture.asset(
                "assets/icons/user-circle.svg",
                width: 156,
                height: 156,
                color: Colors.red.shade900,
              )),
        ),
        Center(
            child: Text(
          'Votre username',
          style:
              TextStyle(fontFamily: 'Sora', fontSize: 24, color: Colors.white),
        )),
      ]),
    );
  }
}

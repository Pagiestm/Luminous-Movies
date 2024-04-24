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
            style: TextStyle(
                fontFamily: 'Sora', fontSize: 24, color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 16)),
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
              style: TextStyle(
                  fontFamily: 'Sora', fontSize: 32, color: Colors.white),
            )),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 48)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                    fontFamily: 'Sora', fontSize: 24, color: Colors.white),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
            TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'votre.email@gmail.com',
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    "assets/icons/email.svg",
                    width: 24,
                    height: 24,
                    color: Color.fromARGB(255, 203, 202, 202),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 85, 84, 84)),
                ),
                filled: true,
                fillColor: Colors.grey.shade700,
              ),
              style: TextStyle(color: Colors.white),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade900)),
                  onPressed: () {
                    print("Hello");
                  },
                  child:
                      Text('Connexion', style: TextStyle(color: Colors.white))),
            ),
          ]),
        ));
  }
}

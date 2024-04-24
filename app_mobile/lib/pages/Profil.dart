import 'package:flutter/material.dart';
import 'package:luminous_movies/models/users.dart';

import '../services/users/users_session.dart';
import 'Connexion.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  User? user = UserSession.getUser();

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Connexion();
    }

    return Center(
      child: Text(
        'Test page 5',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}

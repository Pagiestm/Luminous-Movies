import 'package:flutter/material.dart';
import '../services/users/users_session.dart';
import 'Connexion.dart';

class MaListe extends StatelessWidget {
  const MaListe({super.key});

  @override
  Widget build(BuildContext context) {
  String? user = UserSession.getUser();
  if (user == null) {
    return Connexion();
  }
    return Center(
      child: Text(
        'Test page 2',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
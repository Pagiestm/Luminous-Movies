import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/users/users_session.dart';
import '../models/users.dart';
import 'Connexion.dart';

class MaListe extends StatelessWidget {
  const MaListe({super.key});

  @override
  Widget build(BuildContext context) {
  String? userSession = UserSession.getUser();
  
  if (userSession == null) {
    return Connexion();
  }else {
    final userMap = jsonDecode(userSession) as Map<String, dynamic>;
    final user = User.fromJson(userMap);
  }
    return Center(
      child: Text(
        'Test page 2',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
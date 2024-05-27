import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_movies/models/users.dart';
import 'package:session_manager/session_manager.dart';
import 'package:elegant_notification/elegant_notification.dart';

import '../navbar_admin.dart';
import '../services/users/users_auth.dart';
import '../services/users/users_session.dart';
import 'Connexion.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  MyProfil createState() => MyProfil();
}

class MyProfil extends State<Profil> {
  User? user = UserSession.getUser();
  bool toLogin = false;
  bool isEditingPseudo = false;
  bool isAdmin = false;

  final emailController = TextEditingController();
  final pseudoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserAuth.userRole().listen((role) {
      setState(() {
        isAdmin = role == 'admin';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || toLogin) {
      return Connexion();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mon profil',
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEditingPseudo
                        ? Expanded(
                            child: TextField(
                              controller: pseudoController,
                              style: GoogleFonts.sora(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                              onSubmitted: (newPseudo) {
                                UserAuth().updateUser(
                                    user!.id, user!.email, newPseudo);
                                setState(() {
                                  user!.pseudo = newPseudo;
                                  isEditingPseudo = false;
                                });
                              },
                            ),
                          )
                        : Text(
                            user!.pseudo,
                            style: GoogleFonts.sora(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                    IconButton(
                      icon: isEditingPseudo
                          ? Icon(Icons.check)
                          : Icon(Icons.edit),
                      onPressed: () {
                        if (isEditingPseudo) {
                          UserAuth().updateUser(
                              user!.id, user!.email, pseudoController.text);
                          setState(() {
                            user!.pseudo = pseudoController.text;
                            isEditingPseudo = false;
                          });
                          ElegantNotification.success(
                            title: Text("Mise à jour du pseudo",
                                style: TextStyle(color: Colors.black)),
                            description: Text("Pseudo mis à jour avec succès !",
                                style: TextStyle(color: Colors.black)),
                          ).show(context);
                        } else {
                          setState(() {
                            isEditingPseudo = true;
                            pseudoController.text = user!.pseudo;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 48)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: GoogleFonts.sora(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                TextField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: user!.email,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: 'Sora',
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0), // Ajoutez un padding pour l'icône
                      child: Transform.scale(
                        scale: 0.8, // Modifier l'échelle de l'icône
                        child: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/email.svg",
                            color: Color.fromARGB(255, 170, 170, 170),
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 130, 130, 130)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                  ),
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  enabled: true,
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade900)),
                        onPressed: () async {
                          String newEmail = emailController.text;
                          print("Nouvel email: $newEmail");
                          await UserAuth()
                              .updateUser(user!.id, newEmail, user!.pseudo);
                          ElegantNotification.success(
                            title: Text("Mise à jour de l'e-mail",
                                style: TextStyle(color: Colors.black)),
                            description: Text("Votre e-mail a été mis à jour !",
                                style: TextStyle(color: Colors.black)),
                          ).show(context);
                          setState(() {
                            emailController.text = '';
                            user!.email = newEmail;
                          });
                        },
                        child: Text(
                          'Modifier votre email',
                          style: GoogleFonts.sora(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 16)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mot de passe',
                    style: GoogleFonts.sora(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                TextField(
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: '**********',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: 'Sora',
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0), // Ajoutez un padding pour l'icône
                      child: Transform.scale(
                        scale: 0.8, // Modifier l'échelle de l'icône
                        child: Material(
                          color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/lock-on.svg",
                            color: Color.fromARGB(255, 170, 170, 170),
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 130, 130, 130)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                  ),
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  enabled: true,
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade900)),
                        onPressed: () {
                          print("Mot de passe");
                        },
                        child: Text(
                          'Modifier votre mot de passe',
                          style: GoogleFonts.sora(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 16)),
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Administration',
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade900)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavBarAdmin()),
                          );
                        },
                        child: Text(
                          'Panel Admin',
                          style: GoogleFonts.sora(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Se déconnecter',
                    style: GoogleFonts.sora(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade900)),
                      onPressed: () async {
                        try {
                          await SessionManager().setString("user", "");
                          UserSession.user = null;
                          print("Déconnexion réussie");
                          setState(() => toLogin = true);
                        } catch (e) {
                          print("Erreur lors de la déconnexion : $e");
                        }
                      },
                      child: Text(
                        'Déconnexion',
                        style: GoogleFonts.sora(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 64)),
              ]),
            ),
          ),
        ));
  }
}

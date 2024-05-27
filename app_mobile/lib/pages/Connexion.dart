import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elegant_notification/elegant_notification.dart';

import '../services/users/users_auth.dart';
import 'Inscription.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  ConnexionState createState() {
    return ConnexionState();
  }
}

class ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();
  bool passenable = true;
  bool isLoading = false;
  bool toRegister = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return toRegister
        ? Inscription()
        : Form(
            key: _formKey,
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
                      SizedBox(width: 10),
                      Text('Luminous Movies',
                          style: GoogleFonts.sora(
                            fontSize: 32,
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        style: GoogleFonts.sora(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 15, bottom: 15),
                          suffixIcon: Transform.scale(
                            scale: 0.7, // Modifier l'échelle de l'icône
                            child: Material(
                              color: Colors.transparent,
                              child: SvgPicture.asset(
                                "assets/icons/email.svg",
                                color: Colors.white54,
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: passenable,
                        cursorColor: Colors.white,
                        style: GoogleFonts.sora(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Mot de passe",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 15, bottom: 15),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passenable = !passenable;
                              });
                            },
                            icon: Material(
                              color: Colors.transparent,
                              child: SvgPicture.asset(
                                passenable
                                    ? "assets/icons/lock-on.svg"
                                    : "assets/icons/lock-off.svg",
                                width: 32,
                                height: 32,
                                color: Colors.white54,
                              ),
                            ),
                            color: Colors.grey.shade400,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade900)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              UserAuth()
                                  .fetchUser(emailController.text,
                                      passwordController.text)
                                  .then((user) {
                                    if (user == null) {
                                      // Si l'utilisateur est null, cela signifie que les informations de connexion ne sont pas valides
                                      ElegantNotification.error(
                                        title: Text("Erreur de connexion",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        description: Text(
                                            "Email ou mot de passe invalide",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ).show(context);
                                    }
                                  })
                                  .catchError((e) => throw e)
                                  .whenComplete(
                                      () => setState(() => isLoading = false));
                            }
                          },
                          child: Text("Connexion",
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                color: Colors.white,
                              ))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 18.0)),
                  Text("Pas encore de compte ?",
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        color: Colors.white,
                      )),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 18.0)),
                  TextButton(
                      onPressed: () {
                        setState(() => toRegister = true);
                      },
                      child: Text("S'inscrire",
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ))),
                ]),
          );
  }
}

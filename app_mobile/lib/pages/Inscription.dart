import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/users/users_register.dart';
import 'Connexion.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  InscriptionState createState() {
    return InscriptionState();
  }
}

class InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();

  bool passenable = true;
  bool passenableRepeated = true;
  bool isLoading = false;
  bool toLogin = false;

  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (toLogin) {
      return Connexion();
    }
    return Form(
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
                  controller: pseudoController,
                  cursorColor: Colors.white,
                  style: GoogleFonts.sora(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Pseudo",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    suffixIcon: Transform.scale(
                      scale: 0.6, // Modifier l'échelle de l'icône
                      child: Material(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          "assets/icons/user.svg",
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
                margin: EdgeInsets.only(top: 0),
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
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                    ),
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
                      return 'Entrer une adresse mail';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "Format de mail invalide";
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: repeatedPasswordController,
                  obscureText: passenableRepeated,
                  cursorColor: Colors.white,
                  style: GoogleFonts.sora(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Confirmez le mot de passe",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 15, bottom: 15),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passenableRepeated = !passenableRepeated;
                        });
                      },
                      icon: Material(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          passenableRepeated
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
                    if (repeatedPasswordController.text !=
                        passwordController.text) {
                      return 'Les mots de passe ne sont pas identiques';
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade900)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        UserRegister()
                            .addUser(emailController.text,
                                passwordController.text, pseudoController.text)
                            .then((value) => {
                                  ElegantNotification.success(
                                    title: Text(
                                      "Inscription",
                                      style: GoogleFonts.sora(
                                        fontSize: 24,
                                        color: Colors.black
                                      ),
                                    ),
                                    description: Text(
                                      "Validation de l'inscription.",
                                      style: GoogleFonts.sora(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ).show(context)
                                })
                            .catchError((err) => throw err)
                            .then((value) => setState(() => toLogin = true))
                            .whenComplete(
                                () => setState(() => isLoading = false));
                      }
                    },
                    child: Text(
                      'Inscription',
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
            Padding(padding: const EdgeInsets.symmetric(vertical: 18.0)),
            Text("Déjà un compte ?",
                style: GoogleFonts.sora(
                  fontSize: 24,
                  color: Colors.white,
                )),
            Padding(padding: const EdgeInsets.symmetric(vertical: 18.0)),
            TextButton(
                onPressed: () {
                  setState(() => toLogin = true);
                },
                child: Text(
                  "Se connecter",
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                )),
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      Icon(
                        Icons.movie,
                        color: Colors.red.shade800,
                        size: 30,
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
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: 'Sora',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 20,
                              top: 15,
                              bottom:
                                  15),
                          suffixIcon: Icon(
                            Icons.email,
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
                        controller: passwordController,
                        obscureText: passenable,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Mot de passe",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: "Sora",
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 15, bottom: 15),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passenable = !passenable;
                              });
                            },
                            icon: Icon(
                              passenable
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                  TextButton(
                      onPressed: () {
                        setState(() => toRegister = true);
                      },
                      child: Text("S'inscrire",
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            color: Colors.white,
                          ))),
                ]),
          );
  }
}
